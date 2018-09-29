
{pdfreport}
===========

You can create custom PDF templates for your reports without worrying about the lateX code. The template presented creates a first cover page and following pages with custom header, footer and background.

General use
-----------

Fonction `prepare_for_knit` will prepare everything you need in the directory of your Rmd file. You can even ask it to directly knit your pdf in the `output_dir` directory.

There is a template example in the package that you can prepare with the following command lines. The YAML is automatically filled with the correct options. Run these lines to see the results in PDF.

``` r
library(pdfreport)
prepare_for_knit(rmd.path = system.file("example/template_example.Rmd", package = "pdfreport"),
                 knit = TRUE, output_dir = tempdir())
```

| ![Overview of the PDF template](https://github.com/statnmap/pdfreport/blob/master/img/template_example_demo.png) |
|:----------------------------------------------------------------------------------------------------------------:|
|                             Overview of the PDF template. Title page and normal page.                            |

Installation
------------

Available on Github only.

``` r
# install.packages("devtools")
devtools::install_github("statnmap/pdfreport")
```

Custom parameters
-----------------

You have to fix the following parameters to customise the template with your own information.

### Title page information

``` r
author <- "@StatnMap"
title <- "Title of the report"
description <- "A template for PDF reports"
company <- "ThinkR"
company_url <- "https://rtask.thinkr.fr"
```

### Normal page header and footer

``` r
slogan <- "R report"
created_on <- "Created on"
email <- "sebastien@thinkr.fr"
```

### Other options

``` r
link.col <- "#f67412"
section.color <- "#0099ff"
main.col <- "#192ac7"
lang <- "en" # For latex text formatting specificities, date format, ...
```

### Background

Background are images. This is why header, footer and margins are fixed in this template.
In the package, you will find `svg` files that you can open with "Inkscape" to modify the templates. There is one `svg` file for the title page `Background_Title_light.svg` and one for normal pages `Background_light_topdown.svg`. Export your image as `png` and you will be able to use them as background images. You can also directly use the one provided in the package.

``` r
bg <- system.file("img/Background_lightblue_topdown.png", package = "pdfreport")
bg.title <- system.file("img/Background_Title_lightblue.png", package = "pdfreport")
```

Create your own template
------------------------

**You need to create a Rmd file before.** The function will only help you create the different LateX files and fix options in the YAML to render your PDF. Using `prepare_for_knit`, you will prepare everything you need (files will be copied in your Rmd folder). With option `knit = TRUE`, this will directly render the PDF. But you will still be able to knit your PDF manually if you have to change the content of the Rmd. In this case, try to not modify the YAML or re-run `prepare_for_knit` before.

``` r
# Define your own already created Rmd file
rmd.path <- system.file("example/template_example.Rmd", package = "pdfreport")
# Prepare and run options (All options are listed here)
prepare_for_knit(
  rmd.path, 
  fig_caption = TRUE, keep_tex = FALSE,
  number_sections = TRUE, toc = TRUE,
  lang = lang, out_format = c("pdf_document2", "pdf_book")[1],
  author = author, 
  title = title, description = description,
  email = email,
  slogan = slogan, created_on = created_on,
  bg = bg, bg.title = bg.title,
  link.col = link.col, section.color = section.color, main.col = main.col,
  company = company, company_url = company_url,
  knit = TRUE, output_dir = tempdir())
```

Extra
-----

There are a few extra to color the text according to your options. You can use this lateX code directly in your Rmd file. Knit the `template_example.Rmd` file to test this.

``` md
\majorstylecolor{Text with same color as main title}
\urlstylecolor{Text with same color as url}
\sectionstylecolor{Text with same color as section title}
\keyword{To put some word in darkred}
\advert{To put some words in orange and italic}
```
