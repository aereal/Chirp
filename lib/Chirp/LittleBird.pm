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
    push @{$self->followee}, $other;
    return;
}

sub unfollow {
    my ($self, $other) = @_;
    $self->followee([grep { !($_->name eq $other->name) } @{$self->followee}]);
    return;
}

sub followed {
    my ($self, $other) = @_;
    any { $_ == $other } @{ $self->followee };
}

sub subscriber_of {
    my ($self, $tl) = @_;
    any { $_ eq $self->name } @{ $tl->subscribers };
}

sub home_tl {
    my ($self) = @_;
    Chirp::Timeline->find_home_tl($self) || Chirp::Timeline->new(subscribers => [$self->name]);
}

1;
