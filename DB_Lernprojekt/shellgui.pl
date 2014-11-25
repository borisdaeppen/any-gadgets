use strict;
use warnings;
use feature 'say';

use DBI;
use DBD::mysql;

#print "Content-type: text/html \n\n";

my $platform = "mysql";
my $host     = "localhost";
my $port     = "3306";

my $user     = "vmuser";
my $pw       = "gibbiX12345";
my $data_source_name = "dbi:mysql:examin:localhost:3306";

my $db_handle = DBI->connect($data_source_name,
                          $user,
                          $pw,
                         );

my $standorte = $db_handle->prepare("select * from Rechner");

$standorte->execute;

my $res = $standorte->fetchall_arrayref();

foreach my $row (@{$res}) {
    foreach my $col (@{$row}) {
        print $col;
        print "\t";
    }
    say '';
}

