package test::Chirp::LittleBird;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Test::Name::FromLine;
use List::MoreUtils ':all';
use Data::Dumper;

use lib '../lib';

use Chirp::LittleBird;

subtest initialize => sub {
    new_ok 'Chirp::LittleBird';
};

subtest find => sub {
    subtest 'not registered bird' => sub {
        my $missing_name = 'NOT REGISTERED';
        is 'Chirp::LittleBird'->find($missing_name), undef;
    };

    subtest 'already registered' => sub {
        my $bird = Chirp::LittleBird->new(name => 'REGISTERED');
        is 'Chirp::LittleBird'->find($bird->name), $bird;
    };
};

subtest name => sub {
    subtest nameless => sub {
        my $bird = Chirp::LittleBird->new;
        is $bird->name, '';
    };

    subtest 'name is torippi' => sub {
        my $bird = Chirp::LittleBird->new(name => 'torippi');
        is $bird->name, 'torippi';
    };
};

subtest followee => sub {
    subtest after_initialized => sub {
        my $bird = Chirp::LittleBird->new(name => 'hitagi');
        is_deeply $bird->followee, [];
    };

    subtest 'with initial followee' => sub {
        my $default_followee = [Chirp::LittleBird->new(name => 'koyomi')];
        my $bird = Chirp::LittleBird->new(name => 'hitagi', followee => $default_followee);
        is_deeply $bird->followee, [@$default_followee];
    };
};

subtest follow => sub {
    my $yuno = Chirp::LittleBird->new(name => 'yuno');
    my $miyako = Chirp::LittleBird->new(name => 'miyako');

    ok none { $_->name eq 'miyako' } @{$yuno->followee};
    $yuno->follow($miyako);
    ok any { $_->name eq 'miyako' } @{$yuno->followee};
};

done_testing;
