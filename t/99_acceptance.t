package test::Chirp::acceptance;
use strict;
use warnings;
use parent qw(Test::Class);
use Test::More;
use Test::Name::FromLine;
use List::MoreUtils ':all';

use lib '../lib';

use Chirp::LittleBird;
use Chirp::Timeline;

subtest acceptance => sub {
    my $koyomi = Chirp::LittleBird->new(name => 'Koyomi Araragi');
    my $hitagi = Chirp::LittleBird->new(name => 'Hitagi Senjougahara');
    my $nadeko = Chirp::LittleBird->new(name => 'Nadeko Sengoku');

    diag 'Koyomo follows Hitagi and Nadeko';
    $koyomi->follow($hitagi);
    ok any { $_ eq $hitagi->name } @{ $koyomi->followee },
        "Hitagi is in Koyomi's followee";
    ok any { $_ eq $koyomi->name } @{ $hitagi->followers },
        "Koyomi is in Hitagi's followee";

    diag 'Hitagi and Nadeko tweets';
    my $nadeko_tweet = 'なでこだYO!';
    $nadeko->tweet($nadeko_tweet);

    my $hitagi_tweet = '阿良々木暦、ブッ殺す';
    $hitagi->tweet($hitagi_tweet);
    ok any { $_->{'body'} eq $hitagi_tweet } @{$koyomi->home_tl->tweets};
    ok none { $_->{'body'} eq $nadeko_tweet } @{$koyomi->home_tl->tweets};
};

done_testing;
