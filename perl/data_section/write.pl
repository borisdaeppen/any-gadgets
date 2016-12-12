# http://stackoverflow.com/questions/41061214/write-to-the-data-section-in-perl
use Data::Dumper; # or JSON, YAML, or any other data serializer
package MyPackage;
my $DATA_ptr;
our $state;
INIT {
    $DATA_ptr = tell DATA;
    $state = eval join "", <DATA>;
}

# manipulate $MyPackage::state in this and other scripts
$state->{foo}--;
$state->{bar}++;

END {
    open DATA, '+<', $0;   # $0 is the name of this script
    seek DATA, $DATA_ptr, 0;
    print DATA Data::Dumper::Dumper($state);
    truncate DATA, tell DATA;  # in case new data is shorter than old data
    close DATA;
}
__DATA__
$VAR1 = {
          'foo' => 123,
          'bar' => 42,
};
