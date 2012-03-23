package test::LittleBird;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use List::MoreUtils ':all';

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

subtest follow => sub {
    my $yuno = LittleBird->new(name => 'yuno');
    my $miyako = LittleBird->new(name => 'miyako');

    ok none { $_->name eq 'miyako' } @{$yuno->followee};
    $yuno->follow($miyako);
    ok any { $_->name eq 'miyako' } @{$yuno->followee};
};

done_testing;
