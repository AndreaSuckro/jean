% A customizable thesis package based on the KBS template
%   http://www.informatik.uni-osnabrueck.de/kbs/thesis_KBS.zip
% and the report class.
%
% Written by Sebastian Höffner <shoeffner@uos.de>
%
% Available options:
%
% 10pt/11pt/12pt        Sets the default font size, passed to the report class
% oneside/twoside       Sets the default layout type, passed to the report class
% openright             Recommended for the use with twoside, lets chapters
%                           start on the right side
% draft                 Passed to the graphixc package
% english/german        Determines the language for predefined texts and babel
% utf8/latin1/ansinew   Determines the input encoding, passed to the inputenc
%                           package
% subfiles              If this option is set, the subfiles package is loaded
% bachelor/master       The thesis type (so far only bachelor or master)
%
%%%%%%
% A typical document employing this class should have a structure like this:
%%%%%%
%
% \documentclass[<options>]{base/thesis}
% % additional packages
% 
% % for the pdf meta data to work properly, these have to be set in the preamble
% \institute{<institute>}
% \workgroup{<workgroup>}
% \title{<title>}
% \author{<author>}
% \city{<signcity>}
% \submitdate{\today}
% \firstSupervisor{<first supervisor>}
% \secondSupervisor{<second supervisor>}
%
% \begin{document}
%
% \maketitle
% 
% \begin{abstract}{<optional abstract title>}
% % abstract text
% \end{abstract}
%
% \begin{acknowledgements}
% % acknowledgements
% \end{acknowledgements}
% 
% \tableofcontents
% 
% \mainpart
%
% % the thesis text
%
% \appendix
%
% % appendixcontents: \listoffigures etc.
% 
% \bibliography{thesis_bibliography}
%
% \declaration
%
% \end{document}

% provides Thesis class of December 2014
\ProvidesClass{base/thesis}[2014/12/24 Thesis class]

%%%%%%%%%%%%%%%%%%%%%
%% OPTIONS TO PASS %%
%%%%%%%%%%%%%%%%%%%%%
% default font sizes (pass to cls report)
\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{report}}
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{report}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{report}}

% twoside/oneside (pass to cls report)
\DeclareOption{twoside}{\PassOptionsToClass{\CurrentOption}{report}}
\DeclareOption{oneside}{\PassOptionsToClass{\CurrentOption}{report}}

% openright (pass to cls report)
\DeclareOption{openright}{\PassOptionsToClass{\CurrentOption}{report}}

% draft option (pass to pkg graphicx)
\DeclareOption{draft}{\PassOptionsToPackage{\CurrentOption}{graphicx}}

% encoding (pass to pkg inputenc}
\DeclareOption{utf8}{\PassOptionsToPackage{\CurrentOption}{inputenc}}
\DeclareOption{latin1}{\PassOptionsToPackage{\CurrentOption}{inputenc}}
\DeclareOption{ansinew}{\PassOptionsToPackage{\CurrentOption}{inputenc}}

% use subfiles (recommended)
\newcounter{subfiles}
\setcounter{subfiles}{0}
\DeclareOption{subfiles}{\setcounter{subfiles}{1}}

%%%%%%%%%%%%%%%%%%%%
%% CUSTOM OPTIONS %%
%%%%%%%%%%%%%%%%%%%%

% Thesis type (bachelor, master)
\newcounter{thesistype}
\setcounter{thesistype}{0} % default: bachelor's thesis
\DeclareOption{bachelor}{\setcounter{thesistype}{0}}
\DeclareOption{master}{\setcounter{thesistype}{1}}

% language (english, german)
\newcounter{language}
\setcounter{language}{0}
\DeclareOption{english}{
  \setcounter{language}{0}
  \def\@submitdate{\ifcase\the\month\or
    January\or February\or March\or April\or May\or June\or
    July\or August\or September\or October\or November\or December\fi
    \space \number\the\year%
  }
}
\DeclareOption{german}{
  \setcounter{language}{1}
  \setlength{\parindent}{0pt} % no paragraph indentation in German
  \def\@submitdate{\ifcase\the\month\or
    Januar\or Februar\or M\"arz\or April\or Mai\or Juni\or
    Juli\or August\or September\or Oktober\or November\or Dezember\fi
    \space \number\the\year%
  }
}

% Throw warning for unknown options
\DeclareOption*{\ClassWarning{Thesis class}{Unknown option '\CurrentOption'}}
%\ExecuteOptions{}
\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BASE CLASS / PACKAGES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[a4paper]{report} % gets options from DeclareOptions

\RequirePackage{graphicx} % gets options from DeclareOptions
\graphicspath{{img/}{pics/}{base/}} % default image paths

\RequirePackage{inputenc} % gets options from DeclareOptions
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}

\RequirePackage{ifthen}

\RequirePackage{fancyhdr} % header and footer are adjusted in ADJUSTMENTS
\RequirePackage{typearea} % options are set in ADJUSTMENTS

\RequirePackage{amsmath, amssymb, amsthm, amsfonts} % math packages

\RequirePackage[colorlinks=false, unicode=true, pdfborder={0 0 0}]{hyperref}
\RequirePackage{appendix} % to add appendix to toc
\RequirePackage{epstopdf}

\ifthenelse{\value{subfiles}=1}{\RequirePackage{subfiles}}{} % require subfiles

%%%%%%%%%%%%%%%%%%%
%% CUSTOM FIELDS %%
%%%%%%%%%%%%%%%%%%%
\def\title#1{\gdef\@title{#1}}\def\@title{}
\def\author#1{\gdef\@author{#1}}\def\@author{}
\def\submitdate#1{\gdef\@submitdate{#1}}\def\@submitdate{\today}
\def\city#1{\gdef\@city{#1}}\def\@city{Osnabrück}
\def\firstSupervisor#1{\gdef\@firstSupervisor{#1}}\def\@firstSupervisor{}
\def\secondSupervisor#1{\gdef\@secondSupervisor{#1}}\def\@secondSupervisor{}
\def\workgroup#1{\gdef\@workgroup{#1}}\def\@workgroup{}
\def\institute#1{\gdef\@institute{#1}}\def\@institute{}
\ifthenelse{\value{thesistype} = 1}
  {\ifthenelse{\value{language} = 1}
    {\gdef\@thesistype{Masterarbeit}}
    {\gdef\@thesistype{Master's Thesis}}
  }{\ifthenelse{\value{language} = 1}
    {\gdef\@thesistype{Bachelorarbeit}}
    {\gdef\@thesistype{Bachelor's Thesis}}
  }

\AtBeginDocument{
  \hypersetup{
    pdftitle    = {\@thesistype: \@title},
    pdfauthor   = {\@author},
    pdfsubject  = {\@title},
    pdfcreator  = {LaTeX},
    pdfproducer = {LaTeX}
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ADJUSTMENTS / PAGE LAYOUT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% bibliographystyle (maybe make an option?)
\bibliographystyle{alpha}

% empty blank pages
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
\hbox{}
\thispagestyle{empty}
\newpage
\if@twocolumn\hbox{}\newpage\fi\fi\fi}

% graphics/text fraction on pages
\renewcommand{\floatpagefraction}{.9} % Default: .5
\renewcommand{\textfraction}{.15}     % Default: .2
\renewcommand{\arraystretch}{1.2}

% header and footer (fancyhdr)
\headwidth160mm \lhead[\thepage]{\nouppercase{\rightmark}}
\chead{} \rhead[\nouppercase{\leftmark}]{\thepage}
\cfoot{\textsc{\@title}}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.4pt}

% text area adjustment (typearea)
\areaset[0.75cm]{16cm}{21cm}
\addtolength{\topmargin}{1cm}
\RequirePackage[bf,small]{caption}

% outer pages (abstract, appendix, etc.) in Roman and main part in arabic page 
% numbers
\def\pagenumberformatouter{Roman}
\def\pagenumberformatinner{arabic}

% starts the main part: switches page counter and clears the page
\newcommand{\mainpart}{ % \mainpart
  \cleardoublepage
  \newcounter{outer}\addtocounter{outer}{\value{page}} % save page number
  \pagestyle{fancy}
  %\pagenumbering{\pagenumberformatinner}
}

% starts the \appendix: switches back to outer page numbering and clears the page
\let\oldAppendix\appendix
\renewcommand{\appendix}{ % \appendix
  \cleardoublepage
    \pagenumbering{\pagenumberformatouter}\setcounter{page}{1}
 % \pagenumbering{\pagenumberformatouter}\setcounter{page}{\value{outer}}
  \oldAppendix
  \addappheadtotoc
}

% clear double page before bibliography
\let\oldBibliography\bibliography
\renewcommand{\bibliography}[1]{% \bibliography{<bib file>}
  \cleardoublepage
  \oldBibliography{#1}
}

% clears a doublepage before making the ToC
\let\oldToC\tableofcontents
\renewcommand{\tableofcontents}{\cleardoublepage\oldToC}

% adds no breaking space to \cite{<ref>}
\let\oldCite\cite\def\cite#1{~\oldCite{#1}}

% overwrites \maketitle to insert a well formatted titlepage
\renewcommand{\maketitle}{ % \maketitle
  \pagenumbering{\pagenumberformatinner}
%  \pagenumbering{\pagenumberformatouter}
  \pagestyle{plain}
  \thispagestyle{empty}
  \begin{center}
    \begin{figure}
      \begin{center}
        \vspace{4mm}
        \includegraphics[height=1.5cm]{unilogo}
      \end{center}
    \end{figure}
    \vspace{-4mm}
    \LARGE{\textsc{\@institute}}

    \LARGE{\textsc{\@workgroup}}
    \vfill

    \LARGE{\emph{
      \@thesistype
    }}

    \vspace{8mm}

    \huge{\textbf{\@title}}
    
    \vspace{8mm}
   
    \LARGE{\@author}
   
    \vspace{32mm}

    \large{\@submitdate}
    \vfill

    \begin{tabular}{ll}
      \large
      \ifthenelse{\value{language} = 1}{Erstgutachter:}{First supervisor:}
        & \large \@firstSupervisor \\
      \large
      \ifthenelse{\value{language} = 1}{Zweitgutachter:}{Second supervisor:}
        & \large \@secondSupervisor
    \end{tabular}
  \end{center}
}

\def\declaration{
  \cleardoublepage
  \ifthenelse{\value{language} = 1}{%
    \chapter*{Erkl\"arung der Selbstst\"andigkeit}%
  }{%
    \chapter*{Declaration of Authorship}%
  }
  \thispagestyle{empty}
  \ifthenelse{\value{language} = 1}{%
    Hiermit versichere ich, dass ich die vorliegende Arbeit
    selbst\"andig verfasst und keine anderen als die angegebenen
    Quellen und Hilfsmittel benutzt sowie Zitate kenntlich gemacht
    habe.
  }{%
    I hereby certify that the work presented here is, to the best of my 
    knowledge and belief, original and the result of my own investigations, 
    except as acknowledged, and has not been submitted, either in part or whole,
    for a degree at this or any other university.
  }

  \bigskip\bigskip

  \begin{flushright}
    \@city, \@submitdate
  \end{flushright}
  
  \newpage
  \vspace*{1em}
  \thispagestyle{empty}
}

\renewenvironment{abstract}[1][\@title]{%
  \cleardoublepage
  \thispagestyle{empty}\centerline{\Large{\textbf{#1}}}\medskip%
}{\cleardoublepage}

\newenvironment{acknowledgements}{%
  \cleardoublepage
  \thispagestyle{empty}\par\vspace*{\fill}\section*{%
    \ifthenelse{\value{language} = 1}{Dank}{Acknowledgements}%
  }
}{\cleardoublepage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SPECIAL COMMANDS FROM THESIS_KBS TEMPLATE %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\V}[1]{\text{\boldmath $#1$}} % format for "vector"
\newcommand{\M}[1]{\V{#1}}                % format for "matrix"

% erstellt Liste, bei der alle Eintr"age um <Beispieltext>-Breite einger"uckt sind!
% Parameter: {<Beispieltext>}
\newenvironment{liste}[2][\rm]{\begin{list}{}{\settowidth{\labelwidth}{{#1#2}}
  \setlength{\leftmargin}{\labelwidth}\addtolength{\leftmargin}{\labelsep}
  \addtolength{\leftmargin}{3ex}%
  \setlength{\parsep}{.5ex plus0.2ex minus 0.2ex}%
  \setlength{\itemsep}{1ex}%
  \renewcommand{\makelabel}[1]{{#1##1\hfill}}}}
  {\end{list}}%
%%%%%%%
% liste + "Doppelpunkt" (notwendig, damit Doppenpunkt außerhalb des Stilparameters #1)
\newenvironment{listeDP}[2][\rm]{\begin{list}{}{\settowidth{\labelwidth}{{#1#2}:}
  \setlength{\leftmargin}{\labelwidth}\addtolength{\leftmargin}{\labelsep}
  \addtolength{\leftmargin}{3ex}%
  \setlength{\parsep}{.5ex plus0.2ex minus 0.2ex}%
  \setlength{\itemsep}{1ex}%
  \renewcommand{\makelabel}[1]{{#1##1}:\hfill}}}
  {\end{list}}%
% erstellt BULLET-Liste, bei der alle Eintr"age um <Beispieltext>-Breite einger"uckt sind!
% Parameter: {<Beispieltext>}
\newenvironment{Liste}[2][\rm]{\begin{list}{}{\settowidth{\labelwidth}{\:$\bullet$\: #1#2}
  \setlength{\leftmargin}{\labelwidth}\addtolength{\leftmargin}{\labelsep}
  \addtolength{\leftmargin}{3ex}%
  \setlength{\parsep}{.5ex plus0.2ex minus 0.2ex}%
  \setlength{\itemsep}{1ex}%
  \renewcommand{\makelabel}[1]{\:$\bullet$\, #1##1\hfill}}}
  {\end{list}}%
\newcommand{\grad}{\ensuremath{^{\circ}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%