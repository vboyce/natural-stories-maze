\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stanfordletter}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{letter}}
\ProcessOptions
\LoadClass{letter}
\usepackage[dvips]{graphics}
%\usepackage[businessenvelope]{envlab}

\usepackage{color}
\usepackage[usenames,dvipsnames,svgnames,table]{xcolor}
\definecolor{cardinal}{RGB}{140,21,21}

\raggedright

\setlength{\topmargin}{-.80in}
\setlength{\oddsidemargin}{-.25in}
\setlength{\evensidemargin}{-.25in}
\setlength{\textwidth}{7in}
\setlength{\textheight}{8in}
\setlength{\headsep}{1in}
\setlength{\footskip}{1.125in}

\DeclareFixedFont{\boldfont}{OT1}{cmss}{bx}{n}{8}
\DeclareFixedFont{\regularfont}{OT1}{cmss}{m}{n}{8}
 \DeclareFixedFont{\italicfont}{OT1}{cmr}{m}{it}{10}

\renewcommand*{\opening}[1]{\ifx\@empty\fromaddress
  \thispagestyle{firstpage}%
    {\raggedleft\@date\par}%
  \else  % home address
    \thispagestyle{empty}%
    {\raggedleft\begin{tabular}{l@{}}\ignorespaces
      \fromaddress \\*[2\parskip]%
      \@date \end{tabular}\par}%
  \fi
  \vspace{2\parskip}%
  {\raggedright \toname \\ \toaddress \par}%
  \vspace{2\parskip}%
  #1\par\nobreak}
\renewcommand{\ps@headings}{% 
  \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@oddhead{\slshape\headtoname{} \ignorespaces\toname
                    \@date
                    \hfil \pagename{} \thepage}%
      \let\@evenhead\@oddhead}
\renewcommand*{\opening}[1]{\ifx\@empty\fromaddress
  \thispagestyle{firstpage}%
    \@date\\%
  \else  % home address
    \thispagestyle{empty}%
    {\raggedleft\begin{tabular}{l@{}}\ignorespaces
      \fromaddress \\*[2\parskip]%
      \@date \end{tabular}\par}%
  \fi
  \vspace{2\parskip}%
  {\raggedright \toname \\ \toaddress \par}%
  \vspace{2\parskip}%
  #1\par\nobreak}
\renewcommand*{\signature}[1]{\def\fromsig{\italicfont #1}}
\newcommand{\officename}{Department of Psychology}
\newcommand{\associateofficename}{}
\newcommand{\roomnumber}{}
\newcommand{\phonenum}{}
\newcommand{\faxnum}{}
\newcommand{\website}{}
\newcommand{\email}{vboyce@stanford.edu}
\newcommand{\person}{Veronica Boyce}
\newcommand{\ID}{}
\newsavebox{\logo}
\newsavebox{\contactinfo}
\newsavebox{\phonestuff}


\sbox{\logo}
     {\parbox[t]{12cm}
       {\raisebox{-10mm}{\scalebox{.4}{\includegraphics{SUSig_Seal_Left.pdf}}}}}
\sbox{\contactinfo}
     {\parbox[t]{4cm}
       {\setlength{\baselineskip}{9.2pt}{\boldfont{\color{cardinal} \officename}\\}
	 \regularfont{450 Jane Stanford Way\\ Building 420 \roomnumber\\
	   Stanford, California 94305}}}
\sbox{\phonestuff}
     {\parbox[t]{7.37cm}{\setlength{\baselineskip}{9.2pt}\regularfont{Email\hspace{2mm} \email\\\website}}}
\newsavebox{\nameandtitle}
\sbox{\nameandtitle}
     {\parbox[t]{3in}{\setlength{\baselineskip}{9.2pt}\boldfont{\person}\\\regularfont{\ID\\}}}
\newsavebox{\header}
\arrayrulecolor{cardinal}
\setlength{\arrayrulewidth}{2pt}
\sbox{\header}
     {\parbox[t]{\textwidth}
       {\begin{tabular*}{\textwidth}{lll@{\extracolsep{\fill}}}
	 \raisebox{.05in}{\usebox{\logo}} &&\usebox{\contactinfo} \\
	 &&\\
	 \hline\\
	 \usebox{\nameandtitle}&&\usebox{\phonestuff}\\
	 &&\\
     \end{tabular*}}}

\newsavebox{\footer}

\sbox{\footer}
     {\parbox[t]{\textwidth}{\color{cardinal} \rule{\textwidth}{3mm}}}
%\newsavebox{\envpic}
%\sbox{\envpic}
%     {\parbox[t]{.75in}
%       {\scalebox{.33}{\includegraphics{SUSig_Seal_Left.pdf}}}}
%\newsavebox{\envtop}
%\sbox{\envtop}
%     {\parbox[t]{2.5in}
%       {\setlength{\baselineskip}{9.2pt}\boldfont{\officename\\\associateofficename}}}
%
%\newsavebox{\envbottom}
%\sbox{\envbottom}
%     {\parbox[b]{2.5in}
%       {\setlength{\baselineskip}{9.2pt}\boldfont{Massachusetts Institute of Technology}\\\regularfont{77 Massachusetts Avenue, Building \roomnumber}\\\regularfont{Cambridge, MA 02139-4307}}}
%
%\newsavebox{\envelope}
%\sbox{\envelope}
%     {\parbox[t]{3.25in}
%       {\hspace{.75in}\raisebox{.125in}{\usebox{\envtop}}\\\textcolor{cardinal}{\rule{3.25in}{2pt}}\\\\\usebox{\envpic}\usebox{\envbottom}}}
%
%\renewcommand{\returnaddress}{\protect\usebox{\envelope}}
%
%


%make sure the header goes on the first page
\renewcommand{\ps@firstpage}
	     {\setlength{\headheight}{70pt}\setlength{\headsep}{25pt}%
	       \renewcommand{\@oddhead}{\usebox{\header}}%
	       \renewcommand{\@evenhead}{}\renewcommand{\@evenfoot}{}\renewcommand{\@oddfoot}{\usebox{\footer}}}

\providecommand{\@evenhead}{}\providecommand{\@oddhead}{}
\providecommand{\@evenfoot}{}\providecommand{\@oddfoot}{}

\pagestyle{headings}
