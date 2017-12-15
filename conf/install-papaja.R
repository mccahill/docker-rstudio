r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)

devtools::with_libpaths(new = "/usr/lib/R/library/", install_github('crsh/papaja'))
