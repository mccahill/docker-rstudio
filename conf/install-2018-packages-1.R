r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)

utils::install.packages("shinythemes", dependencies=TRUE )
utils::install.packages("shinydashboard", dependencies=TRUE )
utils::install.packages("shinystan", dependencies=TRUE )

