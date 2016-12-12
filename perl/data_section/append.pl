# http://stackoverflow.com/questions/41061214/write-to-the-data-section-in-perl

use strict;
use warnings;

seek DATA, 0, 2; # go to the end of the source file
my $offset = tell(DATA); # remember where that is

open my $f, '>>', $0 # open source file for appending
    or die $!;       # of course, you could use DATA instead of $f here

seek $f, $offset, 0; # go to the previously recorded position

print $f "This is a test\n"; # put something there

__DATA__
foo bar
