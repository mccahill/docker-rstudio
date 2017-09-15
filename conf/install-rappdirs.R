r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)

utils::install.packages("udunits2")
utils::install.packages("units")
utils::install.packages("sf")
utils::install.packages("rappdirs")
