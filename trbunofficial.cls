% Transportation Research Board conference paper template
% version 4.0
% 
% David R. Pritchard, http://davidpritchard.org
%   1.0   - Mar. 2009
%   1.1   - Sep. 2011, fixes for captions
%   2.0   - Mar. 2012, Reorganized title page incl. automatic counters
%   2.1   - Jul. 2015, Automatic total word counter and more formattings
%   2.1.1 - Jan. 2016, Minor modifications and first uploaded to Github
%   2.1.1 - May. 2016, created a lite version for people to use directly on TeX without Sweave options
%   4.0	  - Jul. 2019, updated template to be compatible with Overleaf and ShareLaTeX

% Official trb manual for authors:
% http://onlinepubs.trb.org/onlinepubs/AM/InfoForAuthors.pdf
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{trbunofficial}[2017/06/10 TRB latex template]

\LoadClass[titlepage, oneside, 12pt]{article}

\RequirePackage[tiny, rm, pagestyles]{titlesec}
\RequirePackage{enumitem}
\RequirePackage{ccaption}
\RequirePackage[fleqn]{amsmath}
\RequirePackage{mathptmx} % Times text series for text and math
% fix the bug that `Package mathptmx Warning: There are no bold math fonts on input line xxx'
\RequirePackage{newtxtext,newtxmath}      % use Times fonts if available on your TeX system
% Some pdf conversion tricks? Unsure.
\RequirePackage[T1]{fontenc}
\RequirePackage{textcomp}
\RequirePackage[pagewise, mathlines]{lineno}
\RequirePackage{geometry}

\RequirePackage[sort&compress, numbers]{natbib}
\RequirePackage{xparse}
\RequirePackage{totcount}
\DeclareOption{numbered}{%
	\linenumbers%
}
\ProcessOptions\relax

% Vars
%------------------------------------------------------------------------------
\def\@AuthorHeaders{Name1, Name2 and Name3}
\newcommand{\AuthorHeaders}[1]{
	\def\@AuthorHeaders{#1}
}

% Page layout
%------------------------------------------------------------------------------ 
\geometry{textwidth=6.5in, textheight=9.0in}
\geometry{top=1in, left=1in}
\geometry{headheight=0.3in, headsep=0.2in}

% Text formatting
%------------------------------------------------------------------------------ 
\setlength{\parindent}{0.5in}


% Header
%------------------------------------------------------------------------------
\newpagestyle{main}{
	\sethead{\@AuthorHeaders}{}{\thepage}
}
\pagestyle{main}

% HEADINGS
%------------------------------------------------------------------------------
% Line spacing: 12pt before section titles
\renewcommand*{\refname}{\uppercase{References}}
\titleformat{\section}{\bfseries}{}{0pt}{\uppercase}
\titlespacing*{\section}{0pt}{12pt}{*0}
\titleformat{\subsection}{\bfseries}{}{0pt}{}
\titlespacing*{\subsection}{0pt}{12pt}{*0}
\titleformat{\subsubsection}{\itshape}{}{0pt}{}
\titlespacing*{\subsubsection}{0pt}{12pt}{*0}

% EQUATIONS
%------------------------------------------------------------------------------
\setlength{\mathindent}{1in}
% Set spacing before and after equation to be 0
\g@addto@macro\normalsize{%
	\setlength\abovedisplayskip{6pt}
	\setlength\belowdisplayskip{6pt}
	\setlength\abovedisplayshortskip{3pt}
	\setlength\belowdisplayshortskip{3pt}
}

% LISTS
%------------------------------------------------------------------------------ 
% Adjust lists a little. Not quite perfectly fitting TRB style, but vaguely
% close at least.
\setlist[1]{labelindent=0.5in,leftmargin=*}
\setlist[2]{labelindent=0in,leftmargin=*}
\setlist{nosep} % eliminate extra verticle spacings between items

% CAPTIONS
%------------------------------------------------------------------------------ 
% Get the captions right. Authors must still be careful to use "Title Case"
% for table captions, and "Sentence case." for figure captions.
\renewcommand{\fnum@figure}{\bfseries FIGURE~\thefigure}
\renewcommand{\fnum@table}{\bfseries TABLE~\thetable}
\captiontitlefont{\bfseries \boldmath}
\captiondelim{\;}
%\precaption{\boldmath}


% CITATIONS
%------------------------------------------
% TRB uses an Author (num) citation style. I haven't found a way to make
% LaTeX/Bibtex do this automatically using the standard \cite macro, but
% this modified \trbcite macro does the trick.
\renewcommand{\cite}[1]{(\textit{\citenum{#1}})}
\renewcommand{\citep}[1]{\citeauthor{#1} (\textit{\citenum{#1}})}
\setcitestyle{round}

% Reduce spacing between bibliographic items
\setlength{\bibsep}{0pt plus 0.3ex}


% LINE NUMBERING
%------------------------------------------------------------------------------ 
% Adjust the fond of the line numbering
\renewcommand\linenumberfont{\normalfont\small}


% REFERENCES
% Remove square brackets from the numbering and add indentation to bibliography 
% in the REFERENCES section
\renewcommand\@biblabel[1]{#1.\hspace{0.25in}}

% COUNTERS
%------------------------------------------------------------------------------ 
% TRB requires the total number of words, figures, and tables to be displayed
% on the title page. This is possible under the totcount and the xparse
% packages on CTAN.
%
% Note that a total word count is added in V 2.1 to print a single value that
% is calculated as: numberofwords + numberoffigures*250 + numberoftable*250

% Total world count solution from Tex.SX:
% https://tex.stackexchange.com/q/255940
% https://tex.stackexchange.com/q/448605

\makeatletter
\newread\somefile
\newcounter{totalwordcounter}
\newcounter{wordcounter}

% default: 250 number of words per table
\def\@WordsPerTable{250}
\newcommand{\WordsPerTable}[1]{%
	\def\@WordsPerTable{#1}
}

% TODO: there must be a better way to define this to avoid using 0
% Variable to control manual word counting
\def\@TotalWords{0}
\newcommand{\TotalWords}[1]{%
	\def\@TotalWords{#1}
}

% From totcount package
\regtotcounter{table} 	%count tables
\regtotcounter{figure} 	%count figures

\newcommand{\quickwordcount}[1]{%
	\immediate\write18{texcount -1 -sum -merge #1.tex > #1-words}%
	\immediate\openin\somefile=#1-words%
	\read\somefile to \@@localdummy%
	\immediate\closein\somefile%
	\setcounter{wordcounter}{\@@localdummy}%
	\@@localdummy%
}

\newcommand{\totalwordcount}{%
	\setcounter{totalwordcounter}{\value{wordcounter}}%
	\addtocounter{totalwordcounter}{\numexpr\@WordsPerTable*\totvalue{table}}%
	\number\value{totalwordcounter}% Output the number
	\renewcommand{\totalwordcount}{\number\value{totalwordcounter}}
}

% TODO: find better way than multiple hfill and break to get numbered empty
% lines. Is it really necessary to have empty lines numbered? Its just the way
% users of word deal with that.
\renewcommand{\maketitle}{%
	\thispagestyle{empty}
	\begin{flushleft}
		{\MakeUppercase{\bfseries\@title}}\\
		\hfill\break%
		\hfill\break%
		\hfill\break%
		\@author\\
		\hfill\break%
		\hfill\break%
		\if\@TotalWords 0
			Word Count: \quickwordcount{trb_template}~words $+$ \total{table} table(s) $\times$ \@WordsPerTable\ $=$ \totalwordcount~words\\
		\else
			Word Count: \@TotalWords\ words $+$ \total{table} table(s) $\times$ \@WordsPerTable\ $=$ \the\numexpr\@TotalWords + \totvalue{table}*\@WordsPerTable~words\\
		\fi
		\hfill\break%
		\hfill\break%
		\hfill\break%
		\hfill\break%
		\hfill\break%
		\hfill\break%
		Submission Date: \trbdate
	\end{flushleft}
	\newpage
}
\makeatother


% Set date to be the last time possible anywhere on earth (GMT-12), which is exactly one day behind New Zealand's time zone (GMT+12).
\usepackage{advdate}
\newcommand{\trbdate}{{\AdvanceDate[-1]\today}}
