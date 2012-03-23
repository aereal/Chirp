package test::LittleBird;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

use lib '../lib';

use LittleBird;

subtest initialize => sub {
    new_ok 'LittleBird';
};

done_testing;
