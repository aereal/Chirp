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
use Chirp::Timeline;

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
        my $koyomi = Chirp::LittleBird->new(name => 'koyomi');
        my $bird = Chirp::LittleBird->new(name => 'hitagi', followee => [$koyomi->name]);
        ok any { $_ eq $koyomi->name } @{ $bird->followee };
    };
};

subtest follow => sub {
    my $yuno = Chirp::LittleBird->new(name => 'yuno');
    my $miyako = Chirp::LittleBird->new(name => 'miyako');

    ok none { $_ eq 'miyako' } @{$yuno->followee};
    $yuno->follow($miyako);
    ok any { $_ eq 'miyako' } @{$yuno->followee};
};

subtest unfollow => sub {
    my $sae = Chirp::LittleBird->new(name => 'sae');
    my $hiro = Chirp::LittleBird->new(name => 'hiro');
    $hiro->follow($sae);

    ok any { $_ eq $sae->name } @{ $hiro->followee };
    $hiro->unfollow($sae);
    ok none { $_ eq $sae->name } @{$hiro->followee};
};

subtest followed => sub {
    my $koyomi = Chirp::LittleBird->new(name => 'koyomi');

    subtest 'not followed' => sub {
        my $meme = Chirp::LittleBird->new(name => 'meme');
        ok not $koyomi->followed($meme);
    };

    subtest 'followed' => sub {
        my $hitagi = Chirp::LittleBird->new(name => 'hitagi');
        $koyomi->follow($hitagi);
        ok $koyomi->followed($hitagi);
    };
};

subtest subscriber_of => sub {
    my $aereal = Chirp::LittleBird->new(name => 'aereal');

    subtest 'not subscribed TL' => sub {
        my $tl = Chirp::Timeline->new;
        ok not $aereal->subscriber_of($tl);
    };

    subtest 'subscribed TL' => sub {
        my $tl = Chirp::Timeline->new(subscribers => [$aereal->name]);
        ok $aereal->subscriber_of($tl);
    };
};

subtest pushable => sub {
    my $nori_san = Chirp::LittleBird->new(name => 'Nori');
    my $tl = Chirp::Timeline->new(publishers => [$nori_san->name]);
    ok $nori_san->pushable($tl);
};

subtest home_tl => sub {
    subtest 'case of Nori san' => sub {
        my $nori_san = Chirp::LittleBird->new(name => 'Nori');
        isa_ok $nori_san->home_tl, 'Chirp::Timeline';
        ok $nori_san->pushable($nori_san->home_tl);
    };

    subtest 'case of Nazuna-shi' => sub {
        my $nazuna_shi = Chirp::LittleBird->new(name => 'Nazuna');
        isa_ok $nazuna_shi->home_tl, 'Chirp::Timeline';
        ok $nazuna_shi->pushable($nazuna_shi->home_tl);
    };
};

subtest followers => sub {
    subtest 'isolated bird' => sub {
        my $isolated = Chirp::LittleBird->new(name => 'isolated');
        is_deeply $isolated->followers, [];
    };

    subtest 'Shinobu follows Koyomi' => sub {
        my $koyomi = Chirp::LittleBird->new(name => 'Koyomi');
        my $shinobu = Chirp::LittleBird->new(name => 'Shinobu', followee => [$koyomi->name]);
        ok any { $_ eq $shinobu->name } @{ $koyomi->followers };
    };
};

done_testing;
