available::available("pdfreport")

usethis::create_package("../pdfreport")
usethis::use_build_ignore("devstuff_history.R")


# description ----
library(desc)
unlink("DESCRIPTION")
my_desc <- description$new("!new")
my_desc$set_version("0.0.0.9000")
my_desc$set(Package = "pdfreport")
my_desc$set(Title = "A template for pdf report written in Rmarkdown")
my_desc$set(Description = "Create a tex file that defines caracteristics of your PDF report template.")
my_desc$set("Authors@R",
            'c(
    person("Sebastien", "Rochette", email = "sebastien@thinkr.fr", role = c("aut", "cre"))
  )')
# my_desc$set("VignetteBuilder", "knitr")
my_desc$del("Maintainer")
my_desc$del("URL")
my_desc$del("BugReports")
my_desc$write(file = "DESCRIPTION")

# Licence ----
usethis::use_mit_license("ThinkR")

# Packages ----
usethis::use_roxygen_md()
usethis::use_pipe()
attachment::att_to_description(dir.v = "")
