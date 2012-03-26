package Chirp::Timeline;
use strict;
use warnings;
use Object::Simple -base;
use List::MoreUtils ':all';

our $USER_TLS = {};

has publishers => sub { [] };
has subscribers => sub { [] };
has notifications => sub { [] };

sub find_home_tl {
    my ($class, $user) = @_;
    $USER_TLS->{$user->name};
}

sub new_home_tl {
    my ($class, $user) = @_;
    my $self = $class->new(publishers => [$user->name], subscribers => [$user->name]);
    $USER_TLS->{$user->name} = $self;
    $self;
}

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
