package test::Chirp::Timeline;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Test::Name::FromLine;
use List::MoreUtils ':all';
use Test::Fatal qw/exception lives_ok/;

use lib '../lib';

use Chirp::LittleBird;
use Chirp::Timeline;

subtest initialize => sub {
    new_ok 'Chirp::Timeline';
};

subtest find_home_tl => sub {
    subtest 'not registered TL' => sub {
        my $missing_user = Chirp::LittleBird->new(name => 'missing');
        is 'Chirp::Timeline'->find_home_tl($missing_user), undef;
    };

    subtest 'already registered' => sub {
        my $registered = Chirp::LittleBird->new(name => 'registered');
        my $tl = Chirp::Timeline->new;
        $Chirp::Timeline::USER_TLS->{$registered->name} = $tl;
        is 'Chirp::Timeline'->find_home_tl($registered), $tl;
    };
};

subtest publishers => sub {
    subtest hidden => sub {
        my $tl = Chirp::Timeline->new;
        is_deeply $tl->publishers, [];
    };

    subtest 'nakamura can publish this' => sub {
        my $publisher_name = 'nakamura';
        my $tl = Chirp::Timeline->new(publishers => [$publisher_name]);
        ok any { $_ eq $publisher_name } @{ $tl->publishers };
    };
};

subtest subscribers => sub {
    subtest 'isolated tl' => sub {
        my $tl = Chirp::Timeline->new;
        ok none { defined $_ } @{ $tl->subscribers };
    };

    subtest 'Hitagi subscribes this' => sub {
        my $hitagi = Chirp::LittleBird->new(name => 'Hitagi');
        my $tl = Chirp::Timeline->new(subscribers => [$hitagi->name]);
        ok any { $_ eq $hitagi->name } @{ $tl->subscribers };
    };
};

subtest authorized => sub {
    subtest 'TL not include you' => sub {
        my $you = Chirp::LittleBird->new(name => 'you');
        my $tl = Chirp::Timeline->new;
        ok not $tl->authorized($you->name);
    };

    subtest 'TL include you!' => sub {
        my $you = Chirp::LittleBird->new(name => 'you');
        my $tl = Chirp::Timeline->new(publishers => [$you->name]);
        ok $tl->authorized($you->name);
    };
};

subtest notifications => sub {
    subtest 'empty TL' => sub {
        my $tl = Chirp::Timeline->new;
        ok none { defined $_ } @{ $tl->notifications };
    };

    subtest 'Hitagi create tweet on this TL' => sub {
        my $hitagi = Chirp::LittleBird->new(name => 'Hitagi');
        my $tweet_event = {tweet =>
            {user_name => $hitagi->name, body => 'Araragi Koyomi, Bukkorosu'}};
        my $tl = Chirp::Timeline->new(
            subscribers => [$hitagi->name], notifications => [$tweet_event]);
        ok any { $_ == $tweet_event } @{ $tl->notifications };
    };
};

subtest create_notification => sub {
    subtest 'Karen is not in publishers' => sub {
        my $karen = Chirp::LittleBird->new(name => 'Karen');
        my $notification = {tweet => {user_name => $karen->name, body => 'Hamigaki Daisuki'}};
        my $tl = Chirp::Timeline->new;
        like exception { $tl->create_notification($karen->name, $notification) }, qr/The user is not in publishers/;
    };

    subtest 'Tsukihi is in publishers' => sub {
        my $tsukihi = Chirp::LittleBird->new(name => 'Tsukihi');
        my $notification = {tweet => {user_name => $tsukihi->name, body => 'platinum mukatsuku'}};
        my $tl = Chirp::Timeline->new(publishers => [$tsukihi->name]);

        ok none { $_ == $notification } @{ $tl->notifications };
        lives_ok { $tl->create_notification($tsukihi->name, $notification) };
        ok any { $_ == $notification } @{ $tl->notifications };
    };
};

done_testing;
