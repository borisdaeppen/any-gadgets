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
             . "<h1>Datenbank Projekte in $proj_name</h1><ul>"
             . '<p>Die Datei <i>00_create.sql</i> muss auf der Konsole '
             . 'eingelesen werden.</p>';

    foreach my $file_entry (sort @files) {
        next unless ($file_entry =~ /\.sql$/);
        next if     ($file_entry =~ /^00_/);
        $html .= "<li><a href='$proj_dir/$file_entry'>$file_entry</a></li>";
    }

    $html .= '</ul></body></html>';
    $c->render(text => $html, format => 'html');

};

get '/:project/:sql' => sub {
    my $c        = shift;
    my $proj_dir = $c->param('project');
    my $sql_file = $c->param('sql');

    my $proj_name = $proj_dir;
    if ($proj_dir =~ /proj_([^_]*)_.*/) {
        $proj_name = $1;
    }

    my $data_source_name = "dbi:$platform:$proj_name:$host:$port";

    my $db_handle = DBI->connect($data_source_name,
                                 $user,
                                 $pw,
                                );

    # in der route wird scheinbar das .sql entfernt...
    my @sql_cmds = read_file( "$proj_dir/$sql_file.sql" ) ;

    my $html = "<!DOCTYPE html>\n<html><body>";

    foreach my $sql_cmd (@sql_cmds) {

        next if ($sql_cmd =~ /^\s$/);
print $sql_cmd ."-----\n";
        my $cmd_handle = $db_handle->prepare($sql_cmd);
        
        $cmd_handle->execute;
        
        my $res = $cmd_handle->fetchall_arrayref();
        
        $html .= "<h3>$sql_cmd</h3><table border='1'>";

        foreach my $row (@{$res}) {
            $html .= '<tr>';
            foreach my $col (@{$row}) {
                $html .= '<td>';
                $html .= $col;
                $html .= '</td>';
            }
            $html .= '</tr>';
        }
        $html .= '</table>';
    }
    $html .= '</body></html>';

    $c->render(text => $html, format => 'html');
};

app->start;

