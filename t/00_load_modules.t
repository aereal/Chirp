use strict;
use warnings;
use Test::More;

BEGIN {
  subtest load_modules => sub {
    use_ok 'Chirp::LittleBird';
    use_ok 'Chirp::Timeline';
    use_ok 'Chirp::TimeLine::WithFriends'
  };
}

done_testing;
