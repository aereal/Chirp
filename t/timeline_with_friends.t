package test::Chirp::Timeline::WithFriends;
use strict;
use warnings;
use parent qw(Test::Class);
use Test::More;
use Test::Name::FromLine;
use List::MoreUtils ':all';

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

subtest notifications => sub {
    my $self = Chirp::LittleBird->new(name => 'my self');

    subtest 'others who not followed pushes some notification' => sub {
        my $other = Chirp::LittleBird->new(name => 'other one');

        ok not $self->followed($other);

        my $greeting = 'Hello, my name is ' . $other->name;
        $other->tweet($greeting);

        ok none { $_->{'body'} eq $greeting } @{ $self->home_tl->tweets };
    };

    subtest 'the friend pushes some notification' => sub {
        my $friend = Chirp::LittleBird->new(name => 'friend of mine');
        $self->follow($friend);

        ok $self->followed($friend);

        my $post = '特急列車に乗っちゃって〜';
        $friend->tweet($post);

        ok any { $_->{'body'} eq $post } @{ $self->home_tl->tweets };
    };
};

done_testing;
