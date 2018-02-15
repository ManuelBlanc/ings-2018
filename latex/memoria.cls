%
% memoria.cls
% (c) 2014-2018  M. Blanc
%

%% Definicion del paquete
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{memoria}[2018/02/11 v1.7 Clase para memorias]

%% Basamos esta clase en articulo
\LoadClass[a4paper, 12pt]{article}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions

%% Paquetes de definiciones de macros
\RequirePackage{xparse, pgfkeys}

%% UTF8 + Español (el orden importa)
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[spanish]{babel}

%% Estilos
\RequirePackage{xcolor}                    	% Permite declarar colores
\RequirePackage{titlesec}                  	% Modificar el formato de los titulos
\RequirePackage{graphicx}                  	% Para insertar imagenes
\RequirePackage{a4wide}                    	% Formato del papel con menos margen
\RequirePackage{parskip}                   	% Quita el espacio antes de los parrafos
\RequirePackage[colorlinks=false]{hyperref}	% Enlaces
\RequirePackage{environ}                   	% Declaracion de environments mejorada
\RequirePackage{tabu}                   	% Tablas de verdad

% Datos sobre el articulo
\pgfqkeys{/memoria}{
	universidad/.store in	= \@universidad,
	grado/.store in      	= \@grado,
	asignatura/.store in 	= \@asignatura,
	curso/.store in      	= \@curso,
	autores/.store in    	= \@autores,
	practica/.code 2 args	= {\def\@numpractica{#1}\def\@practica{#2}},
	% Valores por defecto
	universidad	= {<UNIVERSIDAD>},
	grado      	= {<GRADO>},
	asignatura 	= {<ASIGNATURA>},
	curso      	= {<CURSO>},
	autores    	= {<AUTORES>},
	practica   	= {0}{PRACTICA},
}
\NewDocumentCommand{\ConfigurarDocumento}{m}{\pgfqkeys{/memoria}{#1}}

\title{\@practica \\ \@asignatura}
\author{\@autores}

% Para graficos
\graphicspath{ {img/} }
\newcommand{\imagen}[2][1]{\includegraphics[width=#1\textwidth]{#2}}

% Y para tablas
\newenvironment{grupotablas}{%
	\NewEnviron{tabla}[2][]{%
		\begin{subtable}{1\textwidth}
			\centering
			\begin{tabu}{##2}
				\toprule
				\BODY
				\bottomrule
			\end{tabu}
			\caption{##1}
		\end{subtable}
	}%
	\begin{table}[h]
}{%
	\end{table}
}

% Utiles de tablas
\newcommand{\cabeceratabla}[1]{\rowfont[c]{\bfseries}#1\midrule}
\newcommand{\celdadoble}[2]{\begin{tabular}{@{}#1@{}}#2\end{tabular}}
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}


% Configuracion de los titulos
\definecolor{color_barra1}{RGB}{65,126,195}
\definecolor{color_cabecera1}{RGB}{13,51,96}
\definecolor{color_cabecera2}{RGB}{42,92,150}

\def\expandonce#1{\unexpanded\expandafter{#1}}

\NewDocumentCommand{\CabeceraConfigurar}{mm}{
	% Procesamiento de las opciones
	\pgfqkeys{/memoria/#1}{#2}

	% Formato del contador
	{
		\pgfkeysgetvalue{/memoria/#1/contador}{\enum}
		\expandafter\xdef\csname the#1\endcsname%
			{\unexpanded\expandafter{\enum}{#1}}
	}

	% Formato del titulo
	\expandafter\titleformat\csname#1\endcsname%
		[\pgfkeysvalueof{/memoria/#1/forma}]     	% shape
		{\pgfkeysvalueof{/memoria/#1/formato}}   	% format
		{\pgfkeysvalueof{/memoria/#1/etiqueta}}  	% label
		{\pgfkeysvalueof{/memoria/#1/separacion}}	% sep
		{\pgfkeysvalueof{/memoria/#1/antes}}     	% before
		[\pgfkeysvalueof{/memoria/#1/despues}]   	% after
}

\NewDocumentCommand{\CabeceraAlias}{mmo}{
	% Comando de cabecera
	%\expandafter\edef\csname#1\endcsname##1{%
		%\noexpand\setcounter{#2}{##1-1}
		%\expandafter\noexpand\csname#2\endcsname{##1}
		%\noexpand\label{#1:\expandafter\noexpand\csname the#2\endcsname}
	%}

	% Texto de hipervinculos
	\addto\extrasspanish{
		\expandafter\edef\csname#2autorefname\endcsname{#1}
	}

	% Reconfiguracion
	\IfValueT{#3}{\CabeceraConfigurar{#2}{#3}}
}


\setcounter{tocdepth}{2}

\CabeceraConfigurar{section}{%
	forma/.initial     	= {hang},
	contador/.initial  	= {\Roman},
	formato/.initial   	= {\normalfont\Large\bfseries\color{color_cabecera1}},
	etiqueta/.initial  	= {\thesection},
	separacion/.initial	= {1em},%
	antes/.initial     	= {},
	despues/.initial   	= {{\color{color_barra1}\titlerule[0.8pt]}},
}

\CabeceraConfigurar{subsection}{%
	forma/.initial     	= {hang},
	contador/.initial  	= {\alph},
	formato/.initial   	= {\normalfont\large\bfseries\color{color_cabecera2}},
	etiqueta/.initial  	= {\thesubsection)},
	separacion/.initial	= 1em,
	antes/.initial     	= {},
	despues/.initial   	= {},
}

\CabeceraConfigurar{subsubsection}{%
	forma/.initial     	= {hang},
	contador/.initial  	= {\roman},
	formato/.initial   	= {\normalfont\bfseries},
	etiqueta/.initial  	= {\thesubsection.\thesubsubsection.},
	separacion/.initial	= 0.4em,
	antes/.initial     	= {},
	despues/.initial   	= {},
}

\CabeceraConfigurar{paragraph}{%
	forma/.initial     	= {runin},
	contador/.initial  	= {\arabic},
	formato/.initial   	= {\normalfont\bfseries},
	etiqueta/.initial  	= {\thesubsection.\thesubsubsection.},
	separacion/.initial	= 0.4em,
	antes/.initial     	= {},
	despues/.initial   	= {},
}

% Headers & footers
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}

\setlength\headheight{33pt}
\lhead{\includegraphics[height=1cm]{uam.jpg}}
\chead{\shortstack[r]{\normalfont\Large\bfseries \@asignatura \\ \@grado{}}}
\rhead{\shortstack[l]{
\color{color_barra1}\bfseries Curso \@curso         	\\
\color{color_barra1}\bfseries Práctica \@numpractica	%%
}}
\lfoot{\qquad\Roman{page}}
\rfoot{\@autores}
\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{1pt}

% Portada
\newcommand{\portada}[1]{%
	\begin{titlepage}
	\begin{center}
		\rule{\linewidth}{0.5mm}                           	\\[1em]
		{ \LARGE\bfseries \@practica }                     	\\
		\rule{\linewidth}{0.5mm}                           	\\[4em]
		{ \Large \textsc{\@asignatura\ --\ \@universidad} }	\\[3em]
		{ \Large \@autores }                               	\\[0.5em]
		{ \today }                                         	\\[0.5em]
		#1
	\end{center}
	\end{titlepage}
	%\thispagestyle{empty}
}

% Inice
\newcommand{\indice}{%
	\newpage\tableofcontents
	\pagenumbering{roman}
	\setcounter{page}{2}
	%
	\newpage
	\pagenumbering{arabic}
	\setcounter{page}{10}
}
