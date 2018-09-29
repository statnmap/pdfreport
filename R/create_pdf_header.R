#' Create content of latex header.tex file
#'
#' @inheritParams pdf_headerfooter
#' @inheritParams pdf_title
#' @inheritParams pdf_layout
#' @inheritParams pdf_sections

pdf_header <- function(
  author, title, email, description,
  slogan = "R report", created_on = "Created on",
  bg = "Background_dark_topdown_ThinkR.png",
  bg.title = "Background_Title_dark_ThinkR.png",
  link.col = "#FF8000", section.color = "#2447c4",
  main.col = "#192ac7",
  company, company_url) {

  paste('
    % \\documentclass[a4paper]{article}
    % Lang EN = 1, FR = 2
    % \\def\\Lang{\\Sexpr{Lang}} %
    % -- Command to find which language is loaded in babel -- %
    % http://tex.stackexchange.com/questions/287667/ifpackagewith-doesnt-behave-as-i-expected-with-global-options
    \\usepackage{xparse}
    \\ExplSyntaxOn
    \\NewDocumentCommand{\\packageoptionsTF}{mmmm}
    {
    \\stanton_package_options:nnTF { #1 } { #2 } { #3 } { #4 }
    }

    \\cs_new_protected:Nn \\stanton_package_options:nnTF
    {
    \\clist_map_inline:nn { #2 }
    {
    \\clist_if_in:cnTF { opt@#1.sty } { ##1 }
    { #3 } % it is a local option
    {
      \\clist_if_in:cnTF { @classoptionslist } { ##1 }
        { #3 } % it is a global option
          { #4 }
          }
        }
      }
      \\ExplSyntaxOff

      % -- Define a variable depending on language -- %
        \\newcommand{\\Lang}{0}

      \\makeatletter
      \\@ifpackageloaded{babel}{
        \\packageoptionsTF{babel}{english}{%
          \\renewcommand{\\Lang}{1}% english
        }{%
          \\renewcommand{\\Lang}{2}% french
        }
      }{}
      \\makeatother

      % -- Define specific lateX options depending on language -- %
        \\ifnum\\Lang = 1
      % \\usepackage[english]{babel}
      \\usepackage{enumitem}
      \\setlist{itemsep = 0pt}
      \\setlist{topsep = 0pt}
      \\fi
      \\ifnum\\Lang = 2
      % \\usepackage[french]{babel}
      \\fi

      % --
     % \\input{/mnt/Data/ThinkR/Gitlab/vignette-thinkr/latex/MiseEnPageRmd.tex")}
      ', pdf_layout(bg, bg.title, link.col, main.col), '
       % \\input{/mnt/Data/ThinkR/Gitlab/vignette-thinkr/latex/MiseEnFormeTitreFormationRmd.tex")}
      ',pdf_sections(section.color = section.color),'
      % \\input{/mnt/Data/ThinkR/Gitlab/vignette-thinkr/latex/MiseEnFormeTitreFormationRmd_NoSectionBreak.tex}

      ', paste0(pdf_headerfooter(author, email, slogan, created_on,
                                 company, company_url)),'

      % -- Graphic path -- %
      % \\graphicspath{{"/img/"}}

      \\setcounter{section}{0} % Value for first section
      ', pdf_title(author, title, description, company, company_url),'
')
}


#' Format titles
#'
#' @param section.color Color of section titles
#'
#' @importFrom grDevices col2rgb

pdf_sections <- function(section.color = "#2447c4") {

    rgb.sec.col <- c(col2rgb(section.color))

paste0('
  % ----------
% BEGIN pdf_sections
  % ----------
% MISE EN FORME DES TITRES
       % ----------
       %\\renewcommand{\\thesection}{\\arabic{section}}
       %\\renewcommand{\\thesubsection}{\\arabic{section}.\\arabic{subsection}}
       %\\renewcommand{\\thesubsubsection}{\\arabic{section}.\\arabic{subsection}.\\arabic{subsubsection}}

       %% Provide a definition to \\subparagraph to keep titlesec happy
       \\let\\subparagraph\\oldsubparagraph
       \\let\\paragraph\\oldparagraph
       %% Load titlesec
       %\\usepackage[compact]{titlesec}
       \\usepackage{titlesec}
       %% Revert \\subparagraph to the Rmd definition
       % Redefines (sub)paragraphs to behave more like sections
       \\ifx\\paragraph\\undefined\\else
       \\let\\oldparagraph\\paragraph
       \\renewcommand{\\paragraph}[1]{\\oldparagraph{#1}\\mbox{}}
       \\fi
       \\ifx\\subparagraph\\undefined\\else
       \\let\\oldsubparagraph\\subparagraph
       \\renewcommand{\\subparagraph}[1]{\\oldsubparagraph{#1}\\mbox{}}
       \\fi


       %\\titleformat{(command)}[(shape)]{(format)}{(label)}{(sep)}{(before)}[(after)]
       \\titleformat{\\section}%
       [block]% style du titre (block, hang, display, runin, leftmargin, drop, wrap)
       {\\Large\\color[RGB]{',rgb.sec.col[1],',',rgb.sec.col[2],',',rgb.sec.col[3],'}}%changement de fonte commun au numero et au titre
       {\\thesection.}% specification du numero
       {1em}% 1em espace entre le numero et le titre
       {}% changement de fonte du titre

       \\titleformat{\\subsection}%
       [block]% style du titre (block, hang, display, runin, leftmargin, drop, wrap)
       {\\large\\bfseries} %\\itshape {\\Large\\bfseries\\color[RGB]{',rgb.sec.col[1],',',rgb.sec.col[2],',',rgb.sec.col[3],'}}%changement de fonte commun au numero et au titre
       {\\thesubsection.}% specification du numero
       {1em}% {1em}% espace entre le numero et le titre
       {}% changement de fonte du titre

       %\\titlespacing*{(command)}{(left)}{(beforesep)}{(aftersep)}[(right)]
       \\titlespacing*{\\section}{0em}{*4}{*1}

       % A break for each new section with figures printed before new section
       % \\newcommand{\\sectionbreak}{\\clearpage}
       % \\newcommand{\\sectionbreak}{\\clearpage\\phantomsection} % if hyperref loaded before titlesec

       % Title numbering depth
       \\setcounter{secnumdepth}{3}
       % Table of content depth
       \\setcounter{tocdepth}{3}
       \\renewcommand\\contentsname{Content} % toc title

        % Keep color format
        \\newcommand\\sectionstylecolor[1]{\\textcolor[RGB]{',rgb.sec.col[1],',',rgb.sec.col[2],',',rgb.sec.col[3],'}{#1}}


       % -----------
       % MISE EN FORME TEXTES SPECIAUX
       % -----------
       % Additionnal Text colors
       \\usepackage{xcolor}
       \\definecolor{backcolor}{RGB}{235, 235, 235}

       \\newcommand{\\mybox}[1]{\\par\\noindent\\colorbox{backcolor}
       {\\parbox{\\dimexpr\\textwidth-2\\fboxsep\\relax}{#1}}}

       \\newcommand{\\keyword}[1]{\\textcolor{red!60!black}{#1}}
       \\newcommand{\\advert}[1]{\\textit{\\textcolor{orange!80!black}{#1}}}
       \\newcommand{\\exo}[1]{\\textit{\\textcolor{green!80!black}{#1}}}
       %\\newcommand{\\codecommand}[1]{\\par\\noindent\\colorbox{backcolor}{\\texttt{#1}}}
       %\\newcommand{\\menucommand}[1]{\\par\\fontfamily{pcr}\\fontsize{12}{12}\\selectfont\\color{red}\\noindent\\colorbox{shadecolor}{\\textit{#1}}}{\\par}
       \\newcommand{\\menucommand}[1]{\\textit{\\textcolor{blue!80!black}{#1}}}
       \\newcommand{\\codecommand}[1]{\\texttt{\\colorbox{backcolor}{#1}}}

       \\newenvironment{important}{\\par\\color{black!80!green}\\itshape}{\\par}

       \\newsavebox{\\selvestebox}
       \\newenvironment{redbox}
       {
       \\begin{lrbox}{\\selvestebox}%
       \\begin{minipage}{\\dimexpr\\columnwidth-2\\fboxsep\\relax}}
       {\\end{minipage}\\end{lrbox}%
       \\colorbox[HTML]{FF7F7F}{\\usebox{\\selvestebox}}
       }

       % \\newsavebox{\\selvestebox}
       \\newenvironment{codebox}{
       \\begin{lrbox}{\\selvestebox}%
       }{
       \\end{lrbox}%
       \\colorbox{backcolor}{\\usebox{\\selvestebox}}
       }

       % - source: http://tex.stackexchange.com/questions/82028/how-do-i-create-a-variant-of-the-snugshade-box-from-the-framed-package-to-wrap-m
       \\newenvironment{blueShaded}[1][D6E8F5]{
       \\definecolor{shadecolor}{HTML}{#1}%
       \\begin{snugshade}%
       }{%
       \\end{snugshade}%
       }

       % -- command for pandoc trick with \\begin and \\end -- %
       \\newcommand{\\nopandoc}[1]{#1}

       % ----------
       % Pour justifier le texte apres un alignement a gauche
       % Utile pour le texte en caractere tt qui ne se coupe pas
       % ----------
       \\usepackage{ragged2e}

  % ----------
% END pdf_sections
  % ----------
  ')

}
#' Title page of the report
#'
#' @param author Name of the author of the report
#' @param title Title of the report
#' @param description Short description of the report
#' @param company company name
#' @param company_url company_url
#'
pdf_title <- function(author, title, description, company, company_url) {
  paste0('
\\hypersetup{pdfauthor=', gsub("[[:punct:]]", "_", author),', pdftitle=', gsub("[[:punct:]]", "_", title), ', pdfsubject=', gsub("[[:punct:]]", "_", title),', pdfkeywords=R, pdfcreator=pdflatex}

         %----------------------------------------------------------------------------------------
         % TITLE PAGE
         %----------------------------------------------------------------------------------------

         \\newcommand*{\\titleGM}{\\begingroup % Create the command for including the title page in the document
         \\hbox{ % Horizontal box
         %\\hspace*{0.2\\textwidth} % Whitespace to the left of the title page
         %\\hspace*{0.2\\textwidth}
         \\OtherGrey{\\rule{1pt}{\\textheight}} % Vertical line
         \\hspace*{0.05\\textwidth} % Whitespace between the vertical line and title page text
         \\parbox[b]{0.75\\textwidth}{ % Paragraph box which restricts text to less than the width of the page

         {\\noindent\\Huge\\bfseries\\majorstylecolor{', title,'}}\\\\[2\\baselineskip] % Title
         {\\large{', description,'}}\\\\[4\\baselineskip] % Tagline or further description
         {\\Large \\textsc{', author, ', ',company,'}} % Author name

         \\vspace{0.5\\textheight} % Whitespace between the title block and the publisher
         {\\noindent \\href{',company_url,'}{',company,'}}\\\\[\\baselineskip] % Publisher and logo
         }}
         \\endgroup}

         \\AtBeginDocument{\\let\\maketitle\\relax}
         ')
}

#' Create header and footer of the pages
#'
#' @param author Name of the author of the report
#' @param email Email for contact
#' @param slogan Sentence that
#' @param created_on Allow translation for "Created on"
#'
#' @inheritParams pdf_title

pdf_headerfooter <- function(author, email,
                             slogan = "R report", created_on = "Created on",
                             company = "ThinkR", company_url = "https://thinkr.fr") {

  # slogan <- ifelse(lang == "en", "Courses and consulting for R",
  # "Formation et consultance sur R")
  # created_on <- ifelse(lang == "en", "Created on", "Cree le")


  paste0('
     % ---------------
% HEADER / FOOTER
     % ---------------
     \\usepackage{fancyhdr}
     \\pagestyle{fancy}
     %\\fancyhf{}
     \\fancyhead[L]{
     \\hspace{-1cm}\\LARGE{\\textbf{\\href{',company_url,'}{\\majorstylecolor{',company,'}}}}\\\\
     \\hspace{-1cm}\\normalsize{\\Greytext{', slogan, '}}\\\\
     %\\normalsize{\\href{url:https://statnmap.com/}{\\majorstylecolor{http://statnmap.com/}}}
     }
     \\fancyhead[R]{\\Greytext{\\textit{', created_on, ' \\today}\\hspace{-1cm}}}
     %
     \\fancyfoot[L]{\\hspace{-1cm}\\Greytext{', author, '}}
     \\fancyfoot[C]{\\href{mailto:', email, '}{', email, '}}
     \\fancyfoot[R]{\\Greytext{\\thepage\\ / \\pageref*{LastPage}\\hspace{-1cm}}}
     %\\cfoot{Page \\thepage\\ (\\theCurrentPage) of \\lastpageref{LastPages}}
     \\renewcommand{\\headrulewidth}{0pt}
     \\renewcommand{\\footrulewidth}{0pt}
     %\\fancyheadoffset{length}

     ')
}

#' Pdf Layout
#'
#' @param bg path to PNG image used a main background
#' @param bg.title path to PNG image used a Report Title background
#' @param link.col Color in the R language (name or hex)
#' @param main.col Color of the title on the title page and Company name in header
#'
#' @importFrom grDevices col2rgb
#'
pdf_layout <- function(
  bg = "Background_dark_topdown_ThinkR.png",
  bg.title = "Background_Title_dark_ThinkR.png",
  link.col = "#FF8000",
  main.col = "#192ac7") {

  rgb.col <- c(col2rgb(link.col))
  rgb.m.col <- c(col2rgb(main.col))

  paste0('
% === BEGIN OF pdf_layout === %
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{amsmath}
%\\usepackage{amssymb,amsfonts,textcomp}
\\usepackage{color}
\\usepackage{array}
\\usepackage{hhline}
%\\usepackage[linktocpage=true]{hyperref} % to have only number clickable in toc
\\hypersetup{linktocpage=true, colorlinks=true, linkcolor=[RGB]{',rgb.col[1],',',rgb.col[2],',',rgb.col[3],'}, citecolor=[RGB]{',rgb.col[1],',',rgb.col[2],',',rgb.col[3],'}, filecolor=[RGB]{',rgb.col[1],',',rgb.col[2],',',rgb.col[3],'}, urlcolor=[RGB]{',rgb.col[1],',',rgb.col[2],',',rgb.col[3],'}}
%\\usepackage[pdftex]{graphicx}
\\usepackage{tikz}
%\\usepackage{float} % To force figure to be placed where I want with H
% do not use float as it changes space between figures and their caption.
% Better use [!h] option for figures
\\usepackage[normalem]{ulem} % to underline text on multiple lines

\\renewcommand{\\emph}[1]{\\textit{#1}}

\\usepackage{lmodern} % For higher definition fonts
\\usepackage[font = footnotesize, labelfont = bf, margin = 1cm]{caption} %name=Fig.

% Text styles
\\newcommand\\majorstylecolor[1]{\\textcolor[RGB]{',rgb.m.col[1],',',rgb.m.col[2],',',rgb.m.col[3],'}{#1}}
\\newcommand\\urlstylecolor[1]{\\textcolor[RGB]{',rgb.col[1],',',rgb.col[2],',',rgb.col[3],'}{#1}}
\\newcommand\\Greytext[1]{\\textcolor[RGB]{75,75,75}{#1}}
\\newcommand\\LightGrey[1]{\\textcolor[RGB]{173,169,174}{#1}}
\\newcommand\\OtherGrey[1]{\\textcolor[RGB]{200,200,200}{#1}}


% List styles
%\\newcommand\\liststyleWWviiiNumii{%
%\\renewcommand\\labelitemi{{\\textbullet}}
%\\renewcommand\\labelitemii{{\\textbullet}}
%\\renewcommand\\labelitemiii{{\\textbullet}}
%\\renewcommand\\labelitemiv{{\\textbullet}}
%}

\\AtBeginDocument{
\\def\\labelitemi{$\\bullet$}%
\\def\\labelitemii{$\\circ$}%
\\def\\labelitemiii{$-$}%
\\def\\labelitemiv{$-$}%
}

% FIGURES
% \\graphicspath{{/mnt/Data/Formation_SIG-et-R/00_Original_TD_support/img_QGIS/}{/mnt/Data/Formation_SIG-et-R/00_Original_TD_support/figureR/}{/mnt/Data/Formation_SIG-et-R/00_Original_TD_support/Figures_Pres/}{/mnt/Data/autoentrepreneur/Presentation_Produits/SRochettePresentation-img/}}

%\\setlength{\\abovecaptionskip}{5pt}
%\\setlength{\\belowcaptionskip}{10pt}


% DIMENSIONS - MARGINS
% \\usepackage[top=2.4cm, bottom=2.1cm, outer=2cm, inner=4cm, headheight=40pt]{geometry} %heightrounded
%\\setlength\\hoffset{0cm}
%\\setlength\\voffset{0cm}
\\setlength\\topmargin{-2cm}
%\\setlength\\headheight{2cm}
\\setlength\\headsep{0.50cm}
%\\setlength\\textheight{25.7cm}
\\setlength\\footskip{1.1cm}
\\setlength{\\parindent}{0em}
%\\setlength{\\parskip}{0em}
\\setlength\\belowcaptionskip{5pt}
\\setlength\\abovecaptionskip{8pt}
%\\let\\oldfigure\\figure
%\\let\\oldtable\\table
%\\def\\figure{\\setlength\\abovecaptionskip{5pt}\\oldfigure}
%\\def\\table{\\setlength\\belowcaptionskip{1cm}\\oldtable}
%\\usepackage{caption} %[font = small]
%\\setlength{\\abovecaptionskip}{10pt plus 5pt minus 5pt}
%\\captionsetup[table]{skip = 10pt}
%\\captionsetup[figure]{skip = 10pt}
%\\setlength\\longindentation 0.60\\textwidth

% \\usepackage{lastpage} % to calculate number of pages to put in footer
\\usepackage{pageslts}

% ----------
% BACKGROUND
% ----------
\\usepackage{eso-pic}
\\newcommand\\BackgroundPic{%
\\put(0,0){%
\\parbox[b][\\paperheight]{\\paperwidth}{%
\\vfill
\\centering
\\includegraphics[width=\\paperwidth,height=\\paperheight]{', bg, '}%
\\vfill
}}}
\\newcommand\\BackgroundPicTitle{%
\\put(0,0){%
\\parbox[b][\\paperheight]{\\paperwidth}{%
\\vfill
\\centering
\\includegraphics[width=\\paperwidth,height=\\paperheight]{', bg.title, '}%
\\vfill
}}}

%...and this immediately after \\begin{document}:
%\\AddToShipoutPicture*{\\BackgroundPic}
%The * will make sure that the background picture will only be put on one page.
%If you wish to use the picture on multiple pages, skip the *:
%\\AddToShipoutPicture{\\BackgroundPic}
%Then use this command to stop using the background picture:
%\\ClearShipoutPicture

% === END OF pdf_layout === %
   ')
}

#' Create pdf header.tex file
#'
#' @param out.header Path where to save header.tex
#'
#' @inheritParams pdf_header
#'
#' @export

create_pdf_header <- function(
  author = "Author", title  ="Title", description = "Description",
  email = "email@email.com",
  slogan = "R report", created_on = "Created on",
  bg = "Background_dark_topdown_ThinkR.png",
  bg.title = "Background_Title_dark_ThinkR.png",
  link.col = "blue", section.color = "forestgreen",
  main.col = "#192ac7",
  out.header = file.path(tempdir(), "header.tex"),
  company = "Company", company_url = "https://company.fr") {

  cat(
    pdf_header(author, title, email, description,
               slogan, created_on,
               bg,
               bg.title,
               link.col, section.color, main.col,
               company, company_url),
    file = out.header)

  message("A file created: ", out.header)
  return(out.header)
}

#' Prepare yaml for knitting
#'
#' @param rmd.path Path of the Rmd file to be knit
#' @param lang Document language code (e.g. "en", "es", "fr", "pt-BR")
#' @param out_format output pdf format among "pdf_book", "pdf_document2"
#' @details Document dimensions and margins are fixed as linked with background image
#'
#' @inheritParams rmarkdown::pdf_document
#' @inheritParams bookdown::pdf_book
#'
#' @export

prepare_yaml_for_knit <- function(rmd.path, fig_caption = TRUE, keep_tex = FALSE,
                                  number_sections = TRUE, toc = TRUE,
                                  lang = "en", out_format = c("pdf_document2", "pdf_book")) {

  if (missing(rmd.path)) {
    rmd.path <- system.file("example/template_example.Rmd", package = "pdfreport")
  }
  # read in the YAML + src file
  rmd <- readLines(rmd.path)

  # out_format
  out_format <- out_format[1]

  # Find the YAML
  yaml_place <- grep('^---$', rmd)[1:2]

  # Test if output on one line like "output: html_document", add \n
  pos <- grep("^output(\\s)*:", rmd[yaml_place[1]:yaml_place[2]])[1]
  if (!is.na(pos) &
      is.na(grep("^output(\\s)*:(\\s)*$", rmd[yaml_place[1]:yaml_place[2]])[1])) {
    rmd[pos] <- gsub("^output(\\s)*:(\\s)*", "output:\n  ", rmd[pos])
    if (!grepl("default", rmd[pos])) {
      rmd[pos] <- gsub("(\\s)*$", "", rmd[pos])
      rmd[pos] <- paste0(rmd[pos], ": default")
    }
    rmd <- append(rmd, insertion, after = output.place)

    cat(rmd, sep = "\n", file = rmd.path)
    # read in the YAML + src file
    rmd <- readLines(rmd.path)
    # Find the YAML
    yaml_place <- grep('^---$', rmd)[1:2]
  }

  # If already a pdf_book yaml
  pos_pdfbook_start <- grep("pdf_book|pdf_document2", rmd[yaml_place[1]:yaml_place[2]])[1]
  if (!is.na(pos_pdfbook_start)) {
    # Find position of yaml lines starting with two spaces or zero
    pos_levels <- grep("^(\\s){0,2}[[:alpha:]]", rmd[yaml_place[1]:yaml_place[2]])
    pos_pdfbook_end <- pos_levels[which(pos_levels > pos_pdfbook_start)[1]] - 1

    cat(rmd[-c(pos_pdfbook_start:pos_pdfbook_end)], sep = "\n", file = rmd.path)
    # read in the YAML + src file
    rmd <- readLines(rmd.path)
    # Find the YAML
    yaml_place <- grep('^---$', rmd)[1:2]

    message("Previous YAML options for bookdown have been removed")
  }

  # Test if output: \n
  output.place <- grep("^output(\\s)*:(\\s)*$", rmd[yaml_place[1]:yaml_place[2]])[1]
  if (is.na(output.place)) {
    # If output not specified, add just before end of yaml
    output.place <- yaml_place[2] - 1
  }

  # YAML to insert
  insertion <- paste0(
    '  bookdown::', out_format, ':
    fig_caption: ', ifelse(isTRUE(fig_caption), "yes", "no"),'
    highlight: tango
    includes:
      before_body: before_body.tex
      in_header: header.tex
    keep_tex: ', ifelse(isTRUE(keep_tex), "yes", "no"),'
    number_sections: ', ifelse(isTRUE(number_sections), "yes", "no"),'
    toc: ', ifelse(isTRUE(toc), "yes", "no"),''
  )

  # put the yaml in
  rmd <- append(rmd, insertion, after = output.place)
  # cat(rmd, sep = "\n", file = rmd.path)

  # PDF features
  # Find the YAML
  yaml_place <- grep('^---$', rmd)[1:2]
  # Find geometry
  pos <- grep("^geometry", rmd[yaml_place[1]:yaml_place[2]])[1]
  geometry <- "geometry: top=2.4cm, bottom=2.1cm, outer=2cm, inner=4cm, headheight=40pt"
  if (!is.na(pos)) {
    rmd[pos] <- geometry
  } else {
    rmd <- append(rmd, geometry, after = yaml_place[2] - 1)
    yaml_place <- grep('^---$', rmd)[1:2]
  }

  # Find lang
  pos <- grep("^lang", rmd[yaml_place[1]:yaml_place[2]])[1]
  lang <- paste0("lang: ", lang)
  if (!is.na(pos)) {
    rmd[pos] <- lang
  } else {
    rmd <- append(rmd, lang, after = yaml_place[2] - 1)
    yaml_place <- grep('^---$', rmd)[1:2]
  }

  # Find documentclass
  pos <- grep("^documentclass", rmd[yaml_place[1]:yaml_place[2]])[1]
  documentclass <- "documentclass: article"
  if (!is.na(pos)) {
    rmd[pos] <- documentclass
  } else {
    rmd <- append(rmd, documentclass, after = yaml_place[2] - 1)
    yaml_place <- grep('^---$', rmd)[1:2]
  }

  # Find documentclass
  pos <- grep("^classoption", rmd[yaml_place[1]:yaml_place[2]])[1]
  classoption <- "classoption: a4paper"
  if (!is.na(pos)) {
    rmd[pos] <- classoption
  } else {
    rmd <- append(rmd, classoption, after = yaml_place[2] - 1)
    yaml_place <- grep('^---$', rmd)[1:2]
  }

  # Save final document
  cat(rmd, sep = "\n", file = rmd.path)
}

#' Prepare files for knit
#' Prepare everything before knit. You can then knit the bookdown::pdf_book yourself
#'
#' @param knit Logical. Whether to knit document after it has been made ready
#' @param output_dir directory where to save pdf output. Default to Rmd directory
#' @param bg path to background image
#' @param bg.title path to title background image
#'
#' @inheritParams prepare_yaml_for_knit
#' @inheritParams create_pdf_header
#'
#' @examples
#' \dontrun{
#' prepare_for_knit(rmd.path = system.file("example/template_example.Rmd", package = "pdfreport"))
#' prepare_for_knit(rmd.path = system.file("example/template_example.Rmd", package = "pdfreport"),
#' knit = TRUE, output_dir = tempdir())
#' }
#'
#' @importFrom bookdown render_book
#'
#' @export
prepare_for_knit <- function(rmd.path, fig_caption = TRUE, keep_tex = FALSE,
                             number_sections = TRUE, toc = TRUE,
                             lang = "en", out_format = c("pdf_document2", "pdf_book"),
                             author = "Sebastien, @StatnMap", title = "Title of the report",
                             description = "A template for PDF reports",
                             email = "sebastien@thinkr.fr",
                             slogan = "R report", created_on = "Created on",
                             bg, bg.title, link.col = "#f67412", section.color = "#0099ff",
                             main.col = "#192ac7",
                             company = "ThinkR", company_url = "https://rtask.thinkr.fr",
                             knit = FALSE, output_dir) {

  dir <- dirname(rmd.path)
  out.header <- file.path(dir, "header.tex")
  if (missing(output_dir)) {output_dir <- dir}
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  if (missing(bg)) {
    bg <- system.file("img/Background_lightblue_topdown.png", package = "pdfreport")
  }
  if (missing(bg.title)) {
    bg.title <- system.file("img/Background_Title_lightblue.png", package = "pdfreport")
  }


  prepare_yaml_for_knit(rmd.path = rmd.path, fig_caption = fig_caption, keep_tex = keep_tex,
                        number_sections = number_sections, toc = toc,
                        lang = lang, out_format = out_format)
  create_pdf_header(
    author = author, title = title, description = description,
    email = email,
    bg = basename(bg),
    bg.title = basename(bg.title),
    link.col = link.col, section.color = section.color,
    main.col = main.col,
    out.header = file.path(dir, basename(out.header)),
    company = company, company_url = company_url)

  # Copy files
  file.copy(bg, to = file.path(dir, basename(bg)), overwrite = TRUE)
  file.copy(bg.title, to = file.path(dir, basename(bg.title)), overwrite = TRUE)
  file.copy(system.file("latex_files/before_body.tex", package = "pdfreport"),
            to = file.path(dir, "before_body.tex"), overwrite = TRUE)

  if (isTRUE(knit)) {
    origwd <- getwd()
    setwd(dir)
    bookdown::render_book(input = rmd.path)
    output_file <- file.path(output_dir,
                             paste0(gsub(".[[:alnum:]]*$", "", basename(rmd.path)), ".pdf"))
    file.copy("_book/_main.pdf", output_file, overwrite = TRUE)
    unlink("_book", recursive = TRUE)
    setwd(origwd)
    message("Your pdf is ready in ", output_dir, ".\n",
      "Everything is ready to be knit again in directory: ", dir, ".")
  } else {
    message("Everything is ready to knit in directory: ", dir)
  }
}

