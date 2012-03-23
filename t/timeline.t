package test::Chirp::Timeline;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Test::Name::FromLine;

use lib '../lib';

use Chirp::Timeline;

subtest initialize => sub {
    new_ok 'Chirp::Timeline';
};

done_testing;
