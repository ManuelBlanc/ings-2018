# Commando usado para compilar el .tex
# Activamos el modo batch sin interaccion
$pdflatex = 'pdflatex %O -interaction nonstopmode %S';

# Pone el resultado final en la carpeta out/
$out_dir = $aux_dir = 'out';

# Generamos solo un PDF
$pdf_mode = 1; $postscript_mode = $dvi_mode = 0;

# Abre un visor de PDF cuando termina de compilar
$preview_mode = $preview_continuous_mode = 0;
$pvc_view_file_via_temporary = 1;

# Para que se visualize el PDF y no el DVI o PS
$view = 'pdf';

# Algunas variables de entorno que usa pdflatex
use Cwd 'abs_path';
use File::Basename 'dirname';
my $pwd = dirname(abs_path(__FILE__));
$ENV{'TEXINPUTS'}       = $pwd . ':' . ($ENV{'TEXINPUTS'} // '');
$ENV{'max_print_line'}  = 1000; # Cualquier numero
$ENV{'error_line'}      = 254; # Maximo: 254
$ENV{'half_error_line'} = 238; # Maximo: error_line - 16

# vim: ft=perl