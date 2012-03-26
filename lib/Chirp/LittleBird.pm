package Chirp::LittleBird;
use strict;
use warnings;
use Object::Simple -base;
use List::MoreUtils ':all';
use Chirp::Timeline;

has name => '';
has followee => sub { [] };

our $REGISTERED = {};

sub new {
    my ($class, @args) = @_;
    my $self = $class->SUPER::new(@args);
    $REGISTERED->{$self->name} = $self;
    $self;
}

sub find {
    my ($class, $name) = @_;
    $REGISTERED->{$name};
}

sub follow {
    my ($self, $other) = @_;
    push @{$self->followee}, $other->name;
    push @{$self->home_tl->publishers}, $other->name;
    return;
}

sub unfollow {
    my ($self, $other) = @_;
    $self->followee([grep { !($_ eq $other->name) } @{$self->followee}]);
    $self->home_tl->publishers([grep { !($_ eq $other->name) } @{$self->home_tl->publishers}]);
    return;
}

sub followed {
    my ($self, $other) = @_;
    any { $_ eq $other->name } @{ $self->followee };
}

sub subscriber_of {
    my ($self, $tl) = @_;
    any { $_ eq $self->name } @{ $tl->subscribers };
}

sub home_tl {
    my ($self) = @_;
    Chirp::Timeline->find_home_tl($self) || Chirp::Timeline->new_home_tl($self);
}

sub followers {
    my ($self) = @_;
    my $class = ref $self;
    [grep { $class->find($_)->followed($self) } keys %$REGISTERED];
}

sub pushable {
    my ($self, $tl) = @_;
    any { $_ eq $self->name } @{ $tl->publishers };
}

sub tweet {
    my ($self, $body) = @_;
    $self->home_tl->create_notification($self->name, {event => 'tweet', body => $body});
}

1;
