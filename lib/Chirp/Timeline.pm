package Chirp::Timeline;
use strict;
use warnings;
use Object::Simple -base;
use List::MoreUtils ':all';

our $USER_TLS = {};
our $GLOBAL = __PACKAGE__->new;

has publishers => sub { [] };
has subscribers => sub { [] };
has notifications => sub { [] };

sub global {
    $GLOBAL;
}

sub authorized {
    my ($self, $name) = @_;
    any { $_ eq $name } @{ $self->publishers };
}

sub create_notification {
    my ($self, $user_name, $notification) = @_;
    die 'The user is not in publishers' unless $self->authorized($user_name);
    $notification->{'from'} = $user_name;
    push @{ ref($self)->global->notifications }, $notification;
}

sub tweets {
    my ($self) = @_;
    [grep { $_->{'event'} eq 'tweet' } @{$self->notifications}];
}

1;
