package test::Chirp::Timeline::WithFriends;
use strict;
use warnings;
use parent qw(Test::Class);
use Test::More;
use Test::Name::FromLine;

use lib '../lib';

use Chirp::LittleBird;
use Chirp::Timeline;
use Chirp::Timeline::WithFriends;

subtest initialize => sub {
    new_ok 'Chirp::Timeline::WithFriends';
};

subtest inheritance => sub {
    isa_ok 'Chirp::Timeline::WithFriends'->new, 'Chirp::Timeline';
};

done_testing;
