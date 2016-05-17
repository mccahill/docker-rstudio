r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)

devtools::install_github("ismayc/reedoilabs")
devtools::install_github("ismayc/reedtemplates")
utils::install.packages("tufte")