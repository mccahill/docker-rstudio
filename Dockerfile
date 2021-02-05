FROM  ubuntu:20.04

# install R
RUN apt update
RUN apt install -y gnupg2 software-properties-common

# RUN add-apt-repository deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add -
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y r-base r-base-core r-recommended r-base-dev


# we want OpenBLAS for faster linear algebra as described here: http://brettklamer.com/diversions/statistical/faster-blas-in-r/
RUN apt-get install  -y \
   apt-utils \
   libopenblas-base

RUN apt-get update ; \
   DEBIAN_FRONTEND=noninteractive apt-get  install -y  \
   vim \
   less \
   net-tools \
   inetutils-ping \
   curl \
   git \
   telnet \
   nmap \
   socat \
   wget \
   sudo \
   libcurl4-openssl-dev \
   libxml2-dev 

# we need TeX for the rmarkdown package in RStudio, and pandoc is also useful 
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
   texlive \
   texlive-base \
   texlive-latex-extra \
   texlive-pstricks \
   texlive-publishers \
   texlive-fonts-extra \
   texlive-humanities \
   lmodern \
   pandoc \
# dependency for R XML library
  libxml2 \ 
  libxml2-dev \
  libssl-dev 

# R-Studio
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y gdebi-core
RUN DEBIAN_FRONTEND=noninteractive wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.3.1056-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi --n rstudio-server-1.3.1056-amd64.deb
   
# install packages via R scripts found in conf directory
ADD ./conf /r-studio   



# more OS-level libraries
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
  libfreetype6-dev

RUN echo 'force rebuild of R packages'
RUN /usr/bin/R -e 'options(warn=2); install.packages(c(  \
    "R.cache", \
    "R.methodsS3", \
    "R.rsp", \
    "R.utils" \
    ), repos="http://cran.us.r-project.org")'

RUN /usr/bin/R -e 'options(warn=2); install.packages(c( \
    "timeDate", \
    "tidymodels", \
    "tidypredict", \
    "tidyr", \
    "tidyselect", \
    "tidytext", \
    "tidygraph", \
    "tidyverse" \
    ), repos="http://cran.us.r-project.org")'

RUN /usr/bin/R -e 'options(warn=2); install.packages(c( \
    "statmod", \
    "car", \
    "dbplyr", \
    "dplyr", \
    "dygraphs", \
    "evaluate", \
    "forecast", \
    "formatR" \
    ), repos="http://cran.us.r-project.org")'


RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
    libudunits2-dev

RUN /usr/bin/R -e 'options(warn=2); install.packages(c( \
    "gdata", \
    "ggforce", \
    "ggformula", \
    "ggmap", \
    "ggplot2", \
    "ggraph", \
    "ggrepel", \
    "ggridges", \
    "ggstance"  \
    ),  repos="http://cran.us.r-project.org")'

RUN /usr/bin/R -e 'options(warn=2); install.packages(c(  \
    "gmodels", \
    "gtable", \
    "gtools", \
    "import", \
    "jpeg"  \
    ),  repos="http://cran.us.r-project.org")'

RUN /usr/bin/R -e 'options(warn=2); install.packages(c(  \
    "matrixStats", \
    "modelr", \
    "modeltools", \
    "mosaic", \
    "mosaicData", \
    "mvtnorm"  \
    ),  repos="http://cran.us.r-project.org")'
  
RUN /usr/bin/R -e 'options(warn=2); install.packages(c(  \
    "nycflights13", \
    "openintro", \
    "plyr", \
    "png", \
    "purrr", \
    "readr", \
    "readxl"  \
    ), repos="http://cran.us.r-project.org")'
  
RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("chron", "data.table", "rematch", "cellranger", "tidyr", "googlesheets", "hms", "readr", "selectr", "rvest", "pbkrtest"), repos="http://cran.us.r-project.org",quiet=TRUE)'
RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("SparseM", "MatrixModels", "quantreg", "sp", "maptools", "haven", "ellipsis", "forcats", "readxl", "zip", "openxlsx", "rio", "abind", "carData", "car", "mosaicData", "latticeExtra", "gridExtra", "ggdendro", "mnormt", "psych", "generics", "broom", "reshape", "progress", "ggstance", "ggformula", "mosaicCore", "ggrepel", "base64enc", "crosstalk", "htmlwidgets", "png", "raster", "viridis", "leaflet", "mosaic"), repos="http://cran.us.r-project.org",quiet=TRUE)'

# Cliburn Chan requested these:
RUN  DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("maps", "zoo", "gcookbook", "corrplot", "grepel", "base64enc", "crosstalk", "htmlwidgets", "png", "raster", "viridis", "leaflet", "mosaic"), repos="http://cran.us.r-project.org",quiet=TRUE)'
   

# Cliburn also wanted these
# but they have mega-dependencies, so intall them the other way
RUN R CMD BATCH /r-studio/install-dendextend.R
RUN rm /install-dendextend.Rout 
RUN R CMD BATCH /r-studio/install-igraph.R
RUN rm /install-igraph.Rout 

# install sparklyr so we can do Spark via Livy
RUN  DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("config", "dbplyr", "rappdirs", "r2d3", "forge", "sparklyr"), repos="http://cran.us.r-project.org",quiet=TRUE)'
   

# install templates and examples from Reed and the Tufte package
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/BHH2_2016.05.31.tar.gz   
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   BHH2_2016.05.31.tar.gz   
RUN rm \
  BHH2_2016.05.31.tar.gz  



RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("rgdal", "rgeos", "uuid"), repos="http://cran.us.r-project.org",quiet=TRUE)'
RUN R CMD BATCH /r-studio/install-rappdirs.R
RUN rm /install-rappdirs.Rout 
	
# new packages for fall 2018
RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("tigris", "tidycensus", "tidyverse", "future", "doMC", "foreach", "doParallel", "furrr", "drat", "tidygraph", "here", "rticles", "styler", "lintr", "testthat", "reprex", "microbenchmark", "modelr", "globals", "listenv", "iterators", "enc", "rematch2", "rex", "stringdist", "praise", "profmem", "bench" ), repos="http://cran.us.r-project.org",quiet=TRUE)'

RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("pryr", "profvis", "RcppArmadillo", "servr", "xaringan", "rsconnect", "PKI", "RJSONIO", "packrat", "highlight", "pkgdown", "bookdown", "blogdown", "cowplot", "influenceR", "Rook", "rgexf", "visNetwork", "DiagrammeR", "farver", "tweenr", "polyclip", "ggforce", "RgoogleMaps", "rjson", "mapproj", "jpeg", "geosphere", "ggmap", "ggraph", "shinyjs", "flexdashboard"), repos="http://cran.us.r-project.org",quiet=TRUE)'

RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("nycflights13", "babynames", "janeaustenr", "NHANES", "repurrrsive", "infer", "ipred", "numDeriv", "SQUAREM", "lava", "prodlim", "kernlab", "CVST", "DRR", "dimRed", "timeDate", "sfsmisc", "magic", "lpSolve", "RcppProgress", "geometry", "DEoptimR", "robustbase", "ddalpha"), repos="http://cran.us.r-project.org",quiet=TRUE)'
	
RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("gower","RcppRoll", "pls", "recipes", "rsample", "hunspell", "SnowballC", "tokenizers", "ISOcodes", "stopwords", "tidytext", "ggridges", "bayesplot", "matrixStats", "checkmate", "loo", "StanHeaders", "inline", "rstan", "rstantools", "tidypredict"), repos="http://cran.us.r-project.org",quiet=TRUE)'
	
RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("pROC", "gtools", "gdata", "gplots", "MLmetrics", "yardstick", "xgboost", "ModelMetrics", "caret", "e1071", "dotCall64", "spam", "fields", "ROCR", "reticulate", "tfruns", "tensorflow", "zeallot", "keras", "coda", "greta" ), repos="http://cran.us.r-project.org",quiet=TRUE)'

	
RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'install.packages( c("spatialreg", "patchwork", "tmap", "tmaptools"), repos="http://cran.us.r-project.org",quiet=TRUE)'

RUN R CMD BATCH /r-studio/install-2018-packages-1.R
RUN R CMD BATCH /r-studio/install-2018-packages-2.R
RUN R CMD BATCH /r-studio/install-2018-packages-3.R
RUN R CMD BATCH /r-studio/install-2018-packages-4.R

# remove install Rout files
RUN rm \
   /install-2018-packages-1.Rout \
   /install-2018-packages-2.Rout \
   /install-2018-packages-3.Rout \
   /install-2018-packages-4.Rout 
   
# Eric Green requested
RUN DEBIAN_FRONTEND=noninteractive R --vanilla --quiet -e 'remotes::install_github("rstudio-education/dsbox")'

# Supervisord
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor && \
   mkdir -p /var/log/supervisor
CMD ["/usr/bin/supervisord", "-n"]

# Config files
RUN cd /r-studio && \
    cp supervisord-RStudio.conf /etc/supervisor/conf.d/supervisord-RStudio.conf
RUN rm /r-studio/*

# the default packages for everyone running R
RUN echo "" >> /etc/R/Rprofile.site && \
    echo "# add the downloader package to the default libraries" >> /etc/R/Rprofile.site && \
    echo ".First <- function(){" >> /etc/R/Rprofile.site && \
    echo "library(downloader)" >> /etc/R/Rprofile.site && \
    echo "library(knitr)" >> /etc/R/Rprofile.site && \
    echo "library(rmarkdown)" >> /etc/R/Rprofile.site && \
    echo "library(ggplot2)" >> /etc/R/Rprofile.site && \
    echo "library(googlesheets)" >> /etc/R/Rprofile.site && \
    echo "library(lubridate)" >> /etc/R/Rprofile.site && \
    echo "library(stringr)" >> /etc/R/Rprofile.site && \
    echo "library(rvest)" >> /etc/R/Rprofile.site && \
    echo "library(openintro)" >> /etc/R/Rprofile.site && \
    echo "library(broom)" >> /etc/R/Rprofile.site && \
    echo "library(GGally)" >> /etc/R/Rprofile.site && \
    echo "library(babynames)" >> /etc/R/Rprofile.site && \
    echo "library(patchwork)" >> /etc/R/Rprofile.site && \
    echo "}" >> /etc/R/Rprofile.site  && \
    echo "" >> /etc/R/Rprofile.site


###Fall 2020
RUN apt -y install libgdal-dev
RUN Rscript -e 'install.packages("sf")'
RUN Rscript -e 'install.packages("tmap")'
RUN Rscript -e 'install.packages("spatialreg")'
RUN Rscript -e 'install.packages("datasauRus")'
RUN Rscript -e 'install.packages("fivethirtyeight")'
RUN Rscript -e 'install.packages("tufte")'
RUN Rscript -e 'install.packages("skimr")'
RUN Rscript -e 'install.packages("plotROC")'
RUN Rscript -e 'install.packages("dslabs")'
RUN Rscript -e 'install.packages("rms")'
RUN Rscript -e 'install.packages("palmerpenguins")'
RUN Rscript -e 'install.packages("anyflights")'


# add a non-root user so we can log into R studio as that user; make sure that user is in the group "users"
RUN adduser --disabled-password --gecos "" --ingroup users guest 

# add a script that supervisord uses to set the user's password based on an optional
# environmental variable ($VNCPASS) passed in when the containers is instantiated
ADD initialize.sh /


#########
#
# if you need additional tools/libraries, add them here.
# also, note that we use supervisord to launch both the password
# initialize script and the RStudio server. If you want to run other processes
# add these to the supervisord.conf file
#
#########

# expose the RStudio IDE port
EXPOSE 8787 

# set the locale so RStudio doesn't complain about UTF-8
RUN apt-get install  -y locales 
RUN locale-gen en_US en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

CMD ["/usr/bin/supervisord"]