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

subtest name => sub {
    subtest nameless => sub {
        my $bird = LittleBird->new;
        is $bird->name, '';
    };

    subtest 'name is torippi' => sub {
        my $bird = LittleBird->new(name => 'torippi');
        is $bird->name, 'torippi';
    };
};

done_testing;
