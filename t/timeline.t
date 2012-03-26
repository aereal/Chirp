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

subtest global => sub {
    my $first = Chirp::LittleBird->new(name => 'first children');
    my $second = Chirp::LittleBird->new(name => 'second children');
    my $third = Chirp::LittleBird->new(name => 'third children');

    isa_ok 'Chirp::Timeline'->global, 'Chirp::Timeline';
    is 'Chirp::Timeline'->global, 'Chirp::Timeline'->global for (1..10);
    ok all { $_->pushable(Chirp::Timeline->global) } values %{ $Chirp::LittleBird::REGISTERED };

    subtest 'all posts included' => sub {
        my $tweets = [map { [$_, 'Hello, my name is ' . $_->name] } ($first, $second, $third)];
        for (@$tweets) {
            my ($user, $body) = @$_;
            $user->tweet($body);
            ok any { $_->{'body'} eq $body } @{ 'Chirp::Timeline'->global->tweets };
        }
    }
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
        my $tweet_event = {event => 'tweet', user_name => $hitagi->name, body => 'Araragi Koyomi, Bukkorosu'};
        my $tl = Chirp::Timeline->new(
            subscribers => [$hitagi->name], notifications => [$tweet_event]);
        ok any { $_ == $tweet_event } @{ $tl->notifications };
    };
};

subtest create_notification => sub {
    subtest 'Karen is not in publishers' => sub {
        my $karen = Chirp::LittleBird->new(name => 'Karen');
        my $notification = {event => 'tweet', user_name => $karen->name, body => 'Hamigaki Daisuki'};
        my $tl = Chirp::Timeline->new;
        like exception { $tl->create_notification($karen->name, $notification) }, qr/The user is not in publishers/;
    };

    subtest 'Tsukihi is in publishers' => sub {
        my $tsukihi = Chirp::LittleBird->new(name => 'Tsukihi');
        my $notification = {event => 'tweet', user_name => $tsukihi->name, body => 'platinum mukatsuku'};
        my $tl = Chirp::Timeline->global;

        ok none { $_ == $notification } @{ $tl->notifications };
        lives_ok { $tl->create_notification($tsukihi->name, $notification) };
        ok any { $_ == $notification } @{ $tl->notifications };
    };
};

subtest tweets => sub {
    my $kafuka = Chirp::LittleBird->new(name => 'Kafuka Fuura');
    $kafuka->home_tl->create_notification($kafuka->name, {event => 'follow'});
    $kafuka->home_tl->create_notification($kafuka->name, {event => 'unfollow'});
    $kafuka->home_tl->create_notification($kafuka->name, {event => 'tweet'});
    ok all { $_->{'event'} eq 'tweet' } @{ $kafuka->home_tl->tweets };
};

done_testing;
