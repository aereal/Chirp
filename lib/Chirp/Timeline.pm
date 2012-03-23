package Chirp::Timeline;
use strict;
use warnings;
use Object::Simple -base;
use List::MoreUtils ':all';

has publishers => sub { [] };
has subscribers => sub { [] };
has notifications => sub { [] };

sub authorized {
    my ($self, $name) = @_;
    any { $_ eq $name } @{ $self->publishers };
}

sub create_notification {
    my ($self, $user_name, $notification) = @_;
    die 'The user is not in publishers' unless $self->authorized($user_name);
    push @{ $self->notifications }, $notification;
}

1;
