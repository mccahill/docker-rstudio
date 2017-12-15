r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)

devtools::install_github("crsh/papaja")

