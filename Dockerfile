# mccahill/r-studio
#
# VERSION 1.4

FROM ubuntu:18.04
MAINTAINER Mark McCahill "mark.mccahill@duke.edu"

RUN apt-get  update 
RUN apt-get dist-upgrade -y 	
RUN apt-get install -y \
    gnupg2 \
    apt-utils \
    libopenblas-base \
    vim \
    less \
    net-tools \
    inetutils-ping \
    curl \
    git \
    telnet \
    nmap \
    socat \
    software-properties-common \
    wget \
    locales

# Configure default locale
RUN locale-gen en_US en_US.UTF-8 
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

	
# get R from a CRAN archive (we want the 3.5 version of R)
RUN DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# RUN add-apt-repository  "deb http://cran.rstudio.com/bin/linux/ubuntu bionic-cran40/"
RUN add-apt-repository  "deb http://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/"

RUN apt-get  update ; \
    apt-get  dist-upgrade -y 

# we need gdal > 2
# RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
# RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  r-base \
  r-base-dev \
  libcurl4-gnutls-dev \
  libgit2-dev \
  libxml2-dev \
  libssl-dev \
  libudunits2-dev \
  libpoppler-cpp-dev \
  texlive \
  texlive-base \
  texlive-latex-extra \
  texlive-pstricks \
  pandoc \
  texlive-publishers \
  texlive-fonts-extra \
  texlive-latex-extra \
  texlive-humanities \
  lmodern \
  libxml2  \
  libxml2-dev  \
  libssl-dev \
  libproj-dev \
  libudunits2-0  \
  libudunits2-dev \
  software-properties-common \
  gdal-bin \
  python-gdal \
  libgdal-dev \
  gdebi-core \
  libapparmor1 \
  gdal-bin \
  python-gdal \
  libgdal-dev \
  libproj-dev \
  libudunits2-0 \
  libudunits2-dev 

# R-Studio   
# RUN DEBIAN_FRONTEND=noninteractive wget https://download2.rstudio.org/rstudio-server-1.1.383-amd64.deb
# RUN DEBIAN_FRONTEND=noninteractive wget https://s3.amazonaws.com/rstudio-ide-build/server/trusty/amd64/rstudio-server-1.2.907-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive wget https://download2.rstudio.org/server/xenial/amd64/rstudio-server-1.3.959-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi --n rstudio-server-1.3.959-amd64.deb
RUN rm rstudio-server-1.3.959-amd64.deb


# install R packages
ADD pkgInstall.R /usr/local/bin/

# update the R packages we will need for knitr
RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R xfun knitr yaml Rcpp htmltools caTools bitops digest glue stringr \
    markdown highr formatR evaluate mime stringi magrittr

# R packages we need for devtools - and we need devtools to be able to update the rmarkdown package
RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R processx ps callr crayon assertthat cli desc prettyunits backports \
    rprojroot withr pkgbuild rlang rstudioapi pkgload rcmdcheck remotes xopen clipr clisymbols sessioninfo purrr \
    usethis sys askpass openssl brew roxygen2 fs gh rversions git2r devtools R6 httr RCurl BH xml2 curl jsonlite \
    ini downloader memoise plyr XML whisker bitops nloptr

# libraries Eric Green wanted
RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R lubridate lazyeval utf8 fansi zeallot vctrs pillar pkgconfig tibble \
    ggplot2 RColorBrewer dichromat colorspace munsell labeling viridisLite scales stargazer reshape2 gtable proto \
    minqa RcppEigen lme4

# more libraries Mine Cetinakya-Rundel asked for
RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R openintro bindr bindrcpp plogr tidyselect dplyr DBI
  
RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R chron data.table rematch cellranger tidyr googlesheets hms readr \
    selectr rvest pbkrtest

# Shiny
ADD ./conf /r-studio
# RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.14.948-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi -n shiny-server-1.5.14.948-amd64.deb
RUN rm shiny-server-1.5.14.948-amd64.deb

# need these shiny packages
RUN apt-get install -y \
    libcairo2-dev \
    libgtk2.0-dev \
    xvfb \
    libxt-dev \
    libv8-dev

RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R repos=github rstudio/shiny daattali/shinyjs


RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R SparseM MatrixModels quantreg sp maptools haven ellipsis forcats readxl \
    zip openxlsx rio abind carData car mosaicData latticeExtra gridExtra ggdendro mnormt psych generics broom reshape \
    progress GGally ggstance ggformula mosaicCore ggrepel base64enc crosstalk htmlwidgets png raster viridis leaflet mosaic

# Cliburn Chan requested these:
RUN  DEBIAN_FRONTEND=noninteractive pkgInstall.R maps zoo gcookbook corrplot grepel base64enc crosstalk htmlwidgets png \
    raster viridis leaflet mosaic


# install rmarkdown
RUN  DEBIAN_FRONTEND=noninteractive pkgInstall.R repos=github rstudio/rmarkdown

# Cliburn also wanted these
# but they have mega-dependencies, so intall them the other way
RUN  DEBIAN_FRONTEND=noninteractive pkgInstall.R dendextend igraph

# install sparklyr so we can do Spark via Livy
RUN  DEBIAN_FRONTEND=noninteractive pkgInstall.R config dbplyr rappdirs r2d3 forge sparklyr


# install templates and examples from Reed and the Tufte package
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/BHH2_2016.05.31.tar.gz   
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   BHH2_2016.05.31.tar.gz   
RUN rm \
  BHH2_2016.05.31.tar.gz  

RUN  DEBIAN_FRONTEND=noninteractive pkgInstall.R repos=github ismayc/reedoilabs ismayc/reedtemplates andrewpbray/oilabs
RUN  DEBIAN_FRONTEND=noninteractive pkgInstall.R tufte


RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R rgdal rgeos uuid

RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R udunits2 units sf rappdirs

# new packages for fall 2018
RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R tigris tidycensus tidyverse future doMC foreach doParallel furrr drat \
    tidygraph here rticles styler lintr testthat reprex microbenchmark modelr globals listenv iterators enc rematch2 \
    rex stringdist praise profmem bench

RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R pryr profvis RcppArmadillo servr xaringan rsconnect PKI RJSONIO packrat \
    highlight pkgdown bookdown blogdown cowplot influenceR Rook rgexf visNetwork DiagrammeR farver tweenr polyclip \
    ggforce RgoogleMaps rjson mapproj jpeg geosphere ggmap ggraph shinyjs flexdashboard

RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R nycflights13 babynames janeaustenr NHANES repurrrsive infer ipred numDeriv \
    SQUAREM lava prodlim kernlab CVST DRR dimRed timeDate sfsmisc magic lpSolve RcppProgress geometry DEoptimR robustbase \
    ddalpha
	
RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R gower RcppRoll pls recipes rsample hunspell SnowballC tokenizers ISOcodes \
    stopwords tidytext ggridges bayesplot matrixStats checkmate loo StanHeaders inline rstan rstantools tidypredict

RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R pROC gtools gdata gplots MLmetrics yardstick xgboost ModelMetrics caret \
    e1071 dotCall64 spam fields ROCR reticulate tfruns tensorflow zeallot keras coda greta

# install 2018 packages
RUN DEBIAN_FRONTEND=noninteractive pkgInstall.R repos=http://cran.r-project.org \
    shinythemes shinydashboard shinystan rstanarm forecast rstan brms BAS tidyposterior tidymodels tidybayes miniUI

	
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
    echo "}" >> /etc/R/Rprofile.site  && \
    echo "" >> /etc/R/Rprofile.site
	

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

# expose the port for the shiny server
#EXPOSE 3838

CMD ["/usr/bin/supervisord"]
