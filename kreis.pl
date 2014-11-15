# draw an ascii circle
use strict;
use warnings;

# radius
my $r = $ARGV[0] || 15;

# char for drawing
my $c = $ARGV[1] || '.';

# rows are diameter (2 x radius)
for (my $x=1; $x<=$r*2; $x++) {
    # columns are also diameter
    for (my $y=1; $y<=$r*2; $y++) {

        # if Phytagoras tells us point is in radius...
        if (
                (($r - $x)*($r - $x))
              + (($r - $y)*($r - $y))
            
          < $r * $r) {

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
