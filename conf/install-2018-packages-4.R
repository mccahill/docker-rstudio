r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)

utils::install.packages("tidyposterior", dependencies=TRUE )
utils::install.packages("tidymodels", dependencies=TRUE )
utils::install.packages("tidybayes", dependencies=TRUE )
utils::install.packages("miniUI", dependencies=TRUE )
