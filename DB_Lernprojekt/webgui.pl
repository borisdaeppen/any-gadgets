use Mojolicious::Lite;

use feature 'say';

use DBI;
use DBD::mysql;
use File::Slurp 'read_file';
use Cwd;

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
# Startseite mit Projektübersicht
get '/' => sub {
    my $c = shift;

    opendir my $dir_handle, '.';
    my @files = readdir $dir_handle;
    closedir $dir_handle;

    my $html = "<!DOCTYPE html>\n<html><body>"
             . '<h1>Datenbank Projekte</h1><ul>';

    foreach my $file_entry (@files) {
        if ($file_entry =~ /proj_([^_]*)_.*/) {
            $html .= "<li><a href='$file_entry'>$1</a></li>";
        }
    }

    $html .= '</ul></body></html>';

    $c->render(text => $html, format => 'html');
};

get '/:project' => sub {
    my $c        = shift;
    my $proj_dir = $c->param('project');

    my $proj_name = $proj_dir;
    if ($proj_dir =~ /proj_([^_]*)_.*/) {
        $proj_name = $1;
    }

    opendir my $dir_handle, "./$proj_dir";
    my @files = readdir $dir_handle;
    closedir $dir_handle;

    my $html = "<!DOCTYPE html>\n<html><body>"
             . "<h1>Datenbank Projekte in $proj_name</h1><ul>";

    foreach my $file_entry (sort @files) {
        next unless ($file_entry =~ /\.sql$/);
        $html .= "<li><a href='$proj_dir/$file_entry'>$file_entry</a></li>";
    }

    $html .= '</ul></body></html>';
    $c->render(text => $html, format => 'html');

};

get '/:project/:sql' => sub {
    my $c        = shift;
    my $proj_dir = $c->param('project');
    my $sql_file = $c->param('sql');

    # in der route wird scheinbar das .sql entfernt...
    my @sql_cmd = read_file( "$proj_dir/$sql_file.sql" ) ;

    my $standorte = $db_handle->prepare($sql_cmd[0]);
    
    $standorte->execute;
    
    my $res = $standorte->fetchall_arrayref();
    
    my $html = "<!DOCTYPE html>\n<html><body>"
             . "<h3>$sql_cmd[0]</h3><table border='1'>";

    foreach my $row (@{$res}) {
        $html .= '<tr>';
        foreach my $col (@{$row}) {
            $html .= '<td>';
            $html .= $col;
            $html .= '</td>';
        }
        $html .= '</tr>';
    }
    $html .= '</table></body></html>';

    $c->render(text => $html, format => 'html');
};
# Start the Mojolicious command system
app->start;
