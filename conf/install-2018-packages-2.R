r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)


utils::install.packages("rstanarm", dependencies=TRUE )
utils::install.packages("forecast", dependencies=TRUE )
utils::install.packages("rstan", dependencies=TRUE )
