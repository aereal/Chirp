package Chirp::LittleBird;
use strict;
use warnings;
use Object::Simple -base;

has name => '';
has followee => sub { [] };

sub follow {
    my ($self, $other) = @_;
    push @{$self->followee}, $other;
    return;
}

1;
