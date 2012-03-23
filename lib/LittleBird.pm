package LittleBird;
use strict;
use warnings;
use Object::Simple -base;

has name => '';
has followee => sub { [] };

1;
