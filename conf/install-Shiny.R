r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)

devtools::install_github("rstudio/shiny")
devtools::install_github("daattali/shinyjs")