package Chirp::LittleBird;
use strict;
use warnings;
use Object::Simple -base;
use List::MoreUtils ':all';

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

1;
