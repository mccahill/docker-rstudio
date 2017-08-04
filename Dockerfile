# mccahill/r-studio
#
# VERSION 1.1

FROM   ubuntu:16.04
MAINTAINER Mark McCahill "mark.mccahill@duke.edu"

# get R from a CRAN archive 
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >>  /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  E084DAB9

RUN apt-get update ; \
    apt-get dist-upgrade -y 

# we want OpenBLAS for faster linear algebra as described here: http://brettklamer.com/diversions/statistical/faster-blas-in-r/
RUN apt-get install  -y \
   apt-utils \
   libopenblas-base


RUN apt-get update ; \
   DEBIAN_FRONTEND=noninteractive apt-get  install -y  \
   r-base \
   r-base-dev

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
   vim \
   less \
   net-tools \
   inetutils-ping \
   curl \
   git \
   telnet \
   nmap \
   socat \
   python-software-properties \
   wget \
   sudo \
   libcurl4-openssl-dev \
   libxml2-dev 

# we need TeX for the rmarkdown package in RStudio 
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
   texlive \ 
   texlive-base \ 
   texlive-latex-extra \ 
   texlive-pstricks 

# R-Studio
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
   gdebi-core \
   libapparmor1
   
#RUN DEBIAN_FRONTEND=noninteractive wget https://download2.rstudio.org/rstudio-server-1.0.44-amd64.deb
#RUN DEBIAN_FRONTEND=noninteractive gdebi -n rstudio-server-1.0.44-amd64.deb
#RUN rm rstudio-server-1.0.44-amd64.deb

RUN DEBIAN_FRONTEND=noninteractive wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-1.0.143-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi -n rstudio-server-1.0.143-amd64.deb
RUN rm rstudio-server-1.0.143-amd64.deb

# update the R packages we will need for knitr
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/knitr_1.16.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/yaml_2.1.14.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/Rcpp_0.12.12.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/htmltools_0.3.6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/caTools_1.17.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/bitops_1.0-6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/digest_0.6.12.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stringr_1.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/markdown_0.8.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/highr_0.6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/formatR_1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/evaluate_0.10.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mime_0.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stringi_1.1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/magrittr_1.5.tar.gz


RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   bitops_1.0-6.tar.gz \
   caTools_1.17.1.tar.gz \
   digest_0.6.12.tar.gz \
   Rcpp_0.12.12.tar.gz \
   htmltools_0.3.6.tar.gz \
   yaml_2.1.14.tar.gz \
   stringi_1.1.5.tar.gz \
   magrittr_1.5.tar.gz \
   mime_0.5.tar.gz \
   stringr_1.2.0.tar.gz \
   highr_0.6.tar.gz \
   formatR_1.5.tar.gz \
   evaluate_0.10.1.tar.gz \
   markdown_0.8.tar.gz \
   knitr_1.16.tar.gz 

RUN rm \
   evaluate_0.10.1.tar.gz \
   formatR_1.5.tar.gz \
   highr_0.6.tar.gz \
   markdown_0.8.tar.gz \
   stringi_1.1.5.tar.gz \
   magrittr_1.5.tar.gz \
   stringr_1.2.0.tar.gz \
   knitr_1.16.tar.gz \
   yaml_2.1.14.tar.gz \
   Rcpp_0.12.12.tar.gz \
   htmltools_0.3.6.tar.gz \
   caTools_1.17.1.tar.gz \
   bitops_1.0-6.tar.gz \
   digest_0.6.12.tar.gz \
   mime_0.5.tar.gz

# dependency for R XML library
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
   libxml2 \ 
   libxml2-dev \
   libssl-dev


# R packages we need for devtools - and we need devtools to be able to update the rmarkdown package
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/rstudioapi_0.6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/openssl_0.9.6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/withr_2.0.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/brew_1.0-6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stringi_1.1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/magrittr_1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stringr_1.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/Archive/roxygen2/roxygen2_5.0.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rversions_1.0.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/git2r_0.19.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/devtools_1.13.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/R6_2.2.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mime_0.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/httr_1.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/RCurl_1.95-4.8.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/Rcpp_0.12.12.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/BH_1.62.0-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/xml2_1.1.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/curl_2.8.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/jsonlite_1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/digest_0.6.12.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/downloader_0.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/memoise_1.1.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/plyr_1.8.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/XML_3.98-1.9.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/whisker_0.3-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/bitops_1.0-6.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   jsonlite_1.5.tar.gz \
   digest_0.6.12.tar.gz \
   memoise_1.1.0.tar.gz \
   whisker_0.3-2.tar.gz \
   bitops_1.0-6.tar.gz \
   RCurl_1.95-4.8.tar.gz \
   Rcpp_0.12.12.tar.gz \
   plyr_1.8.4.tar.gz \
   R6_2.2.2.tar.gz \
   curl_2.8.1.tar.gz \
   openssl_0.9.6.tar.gz \
   mime_0.5.tar.gz \
   httr_1.2.1.tar.gz \
   rstudioapi_0.6.tar.gz \
   withr_2.0.0.tar.gz \
   git2r_0.19.0.tar.gz \
   devtools_1.13.3.tar.gz \
   brew_1.0-6.tar.gz \
   stringi_1.1.5.tar.gz \
   magrittr_1.5.tar.gz \
   stringr_1.2.0.tar.gz \
   roxygen2_5.0.1.tar.gz \
   XML_3.98-1.9.tar.gz \
   BH_1.62.0-1.tar.gz \
   xml2_1.1.1.tar.gz \
   rversions_1.0.3.tar.gz \
   downloader_0.4.tar.gz

RUN rm \
   jsonlite_1.5.tar.gz \
   digest_0.6.12.tar.gz \
   memoise_1.1.0.tar.gz \
   whisker_0.3-2.tar.gz \
   bitops_1.0-6.tar.gz \
   RCurl_1.95-4.8.tar.gz \
   Rcpp_0.12.12.tar.gz \
   plyr_1.8.4.tar.gz \
   R6_2.2.2.tar.gz \
   mime_0.5.tar.gz \
   httr_1.2.1.tar.gz \
   rstudioapi_0.6.tar.gz \
   openssl_0.9.6.tar.gz \
   withr_2.0.0.tar.gz \
   brew_1.0-6.tar.gz \
   stringi_1.1.5.tar.gz \
   magrittr_1.5.tar.gz \
   stringr_1.2.0.tar.gz \
   roxygen2_5.0.1.tar.gz \
   BH_1.62.0-1.tar.gz \
   XML_3.98-1.9.tar.gz \
   xml2_1.1.1.tar.gz \
   curl_2.8.1.tar.gz \
   rversions_1.0.3.tar.gz \
   git2r_0.19.0.tar.gz \
   devtools_1.13.3.tar.gz \
   downloader_0.4.tar.gz


# the CRAN install from source fails because a server at MIT will not respond
# maybe e can use the Ubuntu distro
#    https://mirrors.nics.utk.edu/cran/src/contrib/nloptr_1.0.4.tar.gz \
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
   r-cran-nloptr


# libraries Eric Green wanted
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/lubridate_1.6.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/assertthat_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/lazyeval_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rlang_0.1.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/tibble_1.3.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/ggplot2_2.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/RColorBrewer_1.1-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/dichromat_2.0-0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/colorspace_1.3-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/munsell_0.4.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/labeling_0.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/scales_0.4.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stargazer_5.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/reshape2_1.4.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/gtable_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/proto_1.0.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/minqa_1.2.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/RcppEigen_0.3.3.3.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/lme4_1.1-13.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   lubridate_1.6.0.tar.gz  \
   gtable_0.2.0.tar.gz \
   RColorBrewer_1.1-2.tar.gz \
   dichromat_2.0-0.tar.gz \
   colorspace_1.3-2.tar.gz \
   munsell_0.4.3.tar.gz \
   labeling_0.3.tar.gz \
   scales_0.4.1.tar.gz \
   proto_1.0.0.tar.gz \
   reshape2_1.4.2.tar.gz \
   assertthat_0.2.0.tar.gz \
   lazyeval_0.2.0.tar.gz \
   rlang_0.1.1.tar.gz \
   tibble_1.3.3.tar.gz \
   ggplot2_2.2.1.tar.gz \
   stargazer_5.2.tar.gz \
   minqa_1.2.4.tar.gz \
   RcppEigen_0.3.3.3.0.tar.gz \
   lme4_1.1-13.tar.gz

RUN rm \
   lubridate_1.6.0.tar.gz  \
   gtable_0.2.0.tar.gz \
   RColorBrewer_1.1-2.tar.gz \
   dichromat_2.0-0.tar.gz \
   colorspace_1.3-2.tar.gz \
   munsell_0.4.3.tar.gz \
   labeling_0.3.tar.gz \
   scales_0.4.1.tar.gz \
   proto_1.0.0.tar.gz \
   reshape2_1.4.2.tar.gz \
   assertthat_0.2.0.tar.gz \
   lazyeval_0.2.0.tar.gz \
   rlang_0.1.1.tar.gz \
   tibble_1.3.3.tar.gz \
   ggplot2_2.2.1.tar.gz \
   stargazer_5.2.tar.gz \
   minqa_1.2.4.tar.gz \
   RcppEigen_0.3.3.3.0.tar.gz \
   lme4_1.1-13.tar.gz
  
# more libraries Mine Cetinakya-Rundel asked for
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/openintro_1.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/tibble_1.3.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/bindr_0.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/bindrcpp_0.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/glue_1.1.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/pkgconfig_2.0.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/plogr_0.1-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/dplyr_0.7.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/assertthat_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/R6_2.2.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/magrittr_1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/lazyeval_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/DBI_0.7.tar.gz 



RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   openintro_1.4.tar.gz \
   assertthat_0.2.0.tar.gz \
   R6_2.2.2.tar.gz \
   magrittr_1.5.tar.gz \
   lazyeval_0.2.0.tar.gz \
   DBI_0.7.tar.gz \
   tibble_1.3.3.tar.gz \
   glue_1.1.1.tar.gz \
   pkgconfig_2.0.1.tar.gz \
   plogr_0.1-1.tar.gz \
   bindr_0.1.tar.gz \
   bindrcpp_0.2.tar.gz \
   dplyr_0.7.2.tar.gz 

RUN rm \
   openintro_1.4.tar.gz \
   assertthat_0.2.0.tar.gz \
   R6_2.2.2.tar.gz \
   magrittr_1.5.tar.gz \
   lazyeval_0.2.0.tar.gz \
   DBI_0.7.tar.gz \
   tibble_1.3.3.tar.gz \
   bindr_0.1.tar.gz \
   bindrcpp_0.2.tar.gz \
   glue_1.1.1.tar.gz \
   pkgconfig_2.0.1.tar.gz \
   plogr_0.1-1.tar.gz \
   dplyr_0.7.2.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/chron_2.3-50.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/data.table_1.10.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rematch_1.0.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/cellranger_1.1.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/tidyr_0.6.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/googlesheets_0.2.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/hms_0.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/readr_1.1.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/purrr_0.2.2.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/selectr_0.3-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rvest_0.3.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/pbkrtest_0.4-7.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   chron_2.3-50.tar.gz \
   data.table_1.10.4.tar.gz \
   rematch_1.0.1.tar.gz \
   cellranger_1.1.0.tar.gz \
   tidyr_0.6.3.tar.gz \
   hms_0.3.tar.gz \
   readr_1.1.1.tar.gz \
   purrr_0.2.2.2.tar.gz \
   googlesheets_0.2.2.tar.gz \
   selectr_0.3-1.tar.gz \
   rvest_0.3.2.tar.gz \
   pbkrtest_0.4-7.tar.gz 

RUN rm \
   chron_2.3-50.tar.gz \
   data.table_1.10.4.tar.gz \
   rematch_1.0.1.tar.gz \
   cellranger_1.1.0.tar.gz \
   tidyr_0.6.3.tar.gz \
   googlesheets_0.2.2.tar.gz \
   hms_0.3.tar.gz \
   readr_1.1.1.tar.gz \
   purrr_0.2.2.2.tar.gz \
   selectr_0.3-1.tar.gz \
   rvest_0.3.2.tar.gz \
   pbkrtest_0.4-7.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/SparseM_1.77.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/MatrixModels_0.4-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/quantreg_5.33.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/car_2.1-5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mosaicData_0.14.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/latticeExtra_0.6-28.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/gridExtra_2.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/ggdendro_0.1-20.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mnormt_1.5-5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/psych_1.7.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/broom_0.4.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/reshape_0.8.6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/prettyunits_1.0.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/progress_1.1.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/GGally_1.3.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/ggformula_0.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mosaicCore_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mosaic_1.0.0.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   SparseM_1.77.tar.gz \
   MatrixModels_0.4-1.tar.gz \
   quantreg_5.33.tar.gz \
   car_2.1-5.tar.gz \
   mosaicData_0.14.0.tar.gz \
   latticeExtra_0.6-28.tar.gz \
   gridExtra_2.2.1.tar.gz \
   ggdendro_0.1-20.tar.gz \
   mnormt_1.5-5.tar.gz \
   psych_1.7.5.tar.gz \
   broom_0.4.2.tar.gz \
   reshape_0.8.6.tar.gz \
   prettyunits_1.0.2.tar.gz \
   progress_1.1.2.tar.gz \
   GGally_1.3.1.tar.gz \
   mosaicCore_0.2.0.tar.gz \
   ggformula_0.5.tar.gz \
   mosaic_1.0.0.tar.gz 

RUN rm \
   SparseM_1.77.tar.gz \
   MatrixModels_0.4-1.tar.gz \
   quantreg_5.33.tar.gz \
   car_2.1-5.tar.gz \
   mosaicData_0.14.0.tar.gz \
   latticeExtra_0.6-28.tar.gz \
   gridExtra_2.2.1.tar.gz \
   ggdendro_0.1-20.tar.gz \
   mnormt_1.5-5.tar.gz \
   psych_1.7.5.tar.gz \
   broom_0.4.2.tar.gz \
   reshape_0.8.6.tar.gz \
   prettyunits_1.0.2.tar.gz \
   progress_1.1.2.tar.gz \
   GGally_1.3.1.tar.gz \
   mosaicCore_0.2.0.tar.gz \
   ggformula_0.5.tar.gz \
   mosaic_1.0.0.tar.gz 

# Cliburn Chan requested these:
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/RColorBrewer_1.1-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/maps_3.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/zoo_1.8-0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/gcookbook_1.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/corrplot_0.77.tar.gz 


RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   RColorBrewer_1.1-2.tar.gz \
   maps_3.2.0.tar.gz \
   zoo_1.8-0.tar.gz \
   gcookbook_1.0.tar.gz \
   corrplot_0.77.tar.gz 


RUN rm \
   RColorBrewer_1.1-2.tar.gz \
   maps_3.2.0.tar.gz \
   zoo_1.8-0.tar.gz \
   gcookbook_1.0.tar.gz \
   corrplot_0.77.tar.gz 

# install rmarkdown
ADD ./conf /r-studio
RUN R CMD BATCH /r-studio/install-rmarkdown.R
RUN rm /install-rmarkdown.Rout 

# CLiburn also wanted these
# dendextend
# igraph
# but they have mega-dependencies, so intall them the other way
RUN R CMD BATCH /r-studio/install-dendextend.R
RUN rm /install-dendextend.Rout 
RUN R CMD BATCH /r-studio/install-igraph.R
RUN rm /install-igraph.Rout 

# Shiny
RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.3.838-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi -n shiny-server-1.5.3.838-amd64.deb
RUN rm shiny-server-1.5.3.838-amd64.deb
RUN R CMD BATCH /r-studio/install-Shiny.R

# install templates and examples from Reed and the Tufte package
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/BHH2_2016.05.31.tar.gz
   
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   BHH2_2016.05.31.tar.gz
   
RUN rm \
  BHH2_2016.05.31.tar.gz
  
RUN R CMD BATCH /r-studio/install-reed.R
RUN rm /install-reed.Rout 


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

# set the locale so RStudio doesn't complain about UTF-8
RUN apt-get install  -y locales 
RUN locale-gen en_US en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales


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
