package Chirp::Timeline;
use strict;
use warnings;
use Object::Simple -base;
use List::MoreUtils ':all';

has publishers => sub { [] };

sub authorized {
    my ($self, $name) = @_;
    any { $_ eq $name } @{ $self->publishers };
}

1;
