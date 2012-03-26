package Chirp::LittleBird;
use strict;
use warnings;
use Object::Simple -base;
use List::MoreUtils ':all';
use Chirp::Timeline;
use Chirp::Timeline::WithFriends;

has name => '';
has followee => sub { [] };
has blocked_users => sub { [] };

our $REGISTERED = {};

sub new {
    my ($class, @args) = @_;
    my $self = $class->SUPER::new(@args);
    $REGISTERED->{$self->name} = $self;
    push @{ 'Chirp::Timeline'->global->publishers }, $self->name;
    $self;
}

sub find {
    my ($class, $name) = @_;
    $REGISTERED->{$name};
}

sub follow {
    my ($self, $other) = @_;
    die "Can't follow" if any { $_ eq $self->name } @{$other->blocked_users};
    push @{$self->followee}, $other->name;
    $self->home_tl->create_notification($self->name, {event => 'follow', from => $self->name, to => $other->name});
    return;
}

sub unfollow {
    my ($self, $other) = @_;
    $self->followee([grep { !($_ eq $other->name) } @{$self->followee}]);
    $self->home_tl->create_notification($self->name, {event => 'unfollow', from => $self->name, to => $other->name});
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
    'Chirp::Timeline::WithFriends'->new(publishers => [@{$self->followee}, $self->name]);
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

sub block {
    my ($self, $other) = @_;
    $other->unfollow($self);
    $self->unfollow($other) if $self->followed($other);
    push @{$self->blocked_users}, $other->name;
}

sub unblock {
    my ($self, $other) = @_;
    $self->blocked_users([grep { !($_ eq $other->name) } @{$self->blocked_users}]);
}

1;
