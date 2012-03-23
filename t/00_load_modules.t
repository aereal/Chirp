use strict;
use warnings;
use Test::More;

BEGIN {
  subtest load_modules => sub {
    use_ok 'LittleBird';
  };
}

done_testing;
