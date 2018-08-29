r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)

utils::install.packages("brms", dependencies=TRUE )
utils::install.packages("BAS", dependencies=TRUE )

