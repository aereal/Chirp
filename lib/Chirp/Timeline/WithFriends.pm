package Chirp::Timeline::WithFriends;
use strict;
use warnings;
use parent qw(Chirp::Timeline);
use List::MoreUtils ':all';

sub notifications {
    my ($self) = @_;
    [grep { my $nf = $_; any { $_ eq $nf->{'from'} } @{$self->publishers} } @{'Chirp::Timeline'->global->notifications}];
}

1;
