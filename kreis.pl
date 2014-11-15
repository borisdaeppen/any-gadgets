# draw an ascii circle
use strict;
use warnings;

# radius
my $r = $ARGV[0] || 20;

# char for drawing
my $c = $ARGV[1] || '.';

# rows are diameter (2 x radius)
for my $x (1 .. $r*2) {
    # columns are also diameter
    for my $y (1 .. $r*2) {

        # if Phytagoras tells us point is in radius...
        if (
                ($r - $x)**2
              + ($r - $y)**2
            
            < $r**2) {

            # ...print a char...
            print $c;
        }
        else {
            # ...otherwise a space
            print ' ';
        }
    }
    # start next row
    print "\n";
}
