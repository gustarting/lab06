#!"C:\xampp\perl\bin\perl.exe"
use strict;
use warnings;
use CGI;
 
my $cgi = CGI->new;
$cgi->charset('UTF-8');
print $cgi->header('text/html; charset=UTF-8');
print <<HTML;
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../styles.css">
    <title>Página de Búsqueda - Universidades licenciadas</title>
  </head>
  <body>
    <div class="site-wrapper">
      <div class="mytitle">
        <b>Resultados de la búsqueda</b>
      </div>
      <div class="content answer">
HTML

my $kind = $cgi->param('kind');
my $keyword = $cgi->param('keyword');
if(!($kind eq "period")){
  $keyword = uc($keyword);
}
my $flag;
open(IN, "../data.csv" ) or die "<h2>Error al abrir el archivo</h2>";
if(<IN>){
  print<<BLOCK;
  <table>
    <tr>
      <th>Código</th>
      <th>Nombre</th>
      <th>Tipo de Gestión</th>
      <th>Estado</th>
      <th>Periodo</th>
      <th>Departamento Filial</th>
      <th>Provincia Filial</th>
      <th>Departamento Local</th>
      <th>Provincia Local</th>
      <th>Distrito Local</th>
      <th>Tipo Autorización</th>
      <th>Programa</th>
      <th>Tipo Nivel Académico</th>
      <th>Nivel Académico</th>
      <th>Tipo de autorización programa</th>
    </tr>
BLOCK
}
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
while(my $line = <IN>){
  my %dict = findInLine($line);
  my $value = $dict{$kind};
  if(defined($value) && $value =~ /.*$keyword.*/){
    if($line =~ m/(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|.+?\|.+?\|(.+?)\|(.+?)\|.+?\|(.+?)\|(.+?)\|(.+?)\|.+?\|.+?\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|.+?\|.+?\|(.+?)\|.+/){
      print "<tr>\n";
      print "<td>$1</td>\n";
      print "<td>$2</td>\n";
      print "<td>$3</td>\n";
      print "<td>$4</td>\n";
      print "<td>$5</td>\n";
      print "<td>$6</td>\n";
      print "<td>$7</td>\n";
      print "<td>$8</td>\n";
      print "<td>$9</td>\n";
      print "<td>$10</td>\n";
      print "<td>$11</td>\n";
      print "<td>$12</td>\n";
      print "<td>$13</td>\n";
      print "<td>$14</td>\n";
      print "<td>$15</td>\n";
      $flag = 1;
      print "</tr>\n";
      next;
    }
  }
}
close(IN);
if(!defined($flag)){
  print "<p>No se encontraron resultados</p>\n";
}
print <<HTML;
        </table>
      </div>
      <div class="back">
        <a href="../consult.html">Volver</a>
      </div>
    </div>
  </body>
</html>
HTML
sub findInLine {
  my %dict = ();
  my $line = $_[0];
  if($line =~ m/.+?\|(.+?)\|.+?\|.+?\|(.+?)\|.+?\|.+?\|.+?\|.+?\|.+?\|(.+?)\|.+?\|.+?\|.+?\|.+?\|.+?\|(.+?)\|.+/){
    $dict{"name"} = $1;
    $dict{"period"} = $2;
    $dict{"localRegion"} = $3;
    $dict{"studyProgram"} = $4;
  }
  return %dict;
}