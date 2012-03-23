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

subtest followee => sub {
    subtest after_initialized => sub {
        my $bird = LittleBird->new(name => 'hitagi');
        is_deeply $bird->followee, [];
    };

    subtest 'with initial followee' => sub {
        my $default_followee = [LittleBird->new(name => 'koyomi')];
        my $bird = LittleBird->new(name => 'hitagi', followee => $default_followee);
        is_deeply $bird->followee, [@$default_followee];
    };
};

done_testing;