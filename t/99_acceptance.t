package test::Chirp::acceptance;
use strict;
use warnings;
use parent qw(Test::Class);
use Test::More;
use Test::Name::FromLine;
use List::MoreUtils ':all';

use lib '../lib';

use Chirp::LittleBird;
use Chirp::Timeline;

done_testing;
