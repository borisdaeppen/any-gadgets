use strict;
use warnings;

my $r = $ARGV[0] || 15;

for (my $x=1; $x<=$r*2; $x++) {
    for (my $y=1; $y<=$r*2; $y++) {
        if (
                (($r - $x)*($r - $x))
              + (($r - $y)*($r - $y))
            
          < $r * $r / 2) {
            print "#";
        }
        else {
            print " ";
        }
    }
    print "\n";
}

#print "\n";

