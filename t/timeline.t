package test::Chirp::Timeline;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Test::Name::FromLine;
use List::MoreUtils ':all';

use lib '../lib';

use Chirp::Timeline;

subtest initialize => sub {
    new_ok 'Chirp::Timeline';
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

done_testing;
