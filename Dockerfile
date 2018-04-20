# mccahill/r-studio
#
# VERSION 1.3

FROM  ubuntu:16.04
MAINTAINER Mark McCahill "mark.mccahill@duke.edu"

# get R from a CRAN archive 
RUN  echo    "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >>    /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  E084DAB9

RUN apt-get  update ; \
    apt-get  dist-upgrade -y 

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

# we need TeX for the rmarkdown package in RStudio, and pandoc is also useful 
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
   texlive \ 
   texlive-base \ 
   texlive-latex-extra \ 
   texlive-pstricks \ 
   pandoc

# R-Studio
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
   gdebi-core \
   libapparmor1
   
RUN DEBIAN_FRONTEND=noninteractive wget https://download2.rstudio.org/rstudio-server-1.1.383-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi --n rstudio-server-1.1.383-amd64.deb
RUN rm rstudio-server-1.1.383-amd64.deb

# update the R packages we will need for knitr
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/knitr_1.20.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/yaml_2.1.18.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/Rcpp_0.12.16.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/htmltools_0.3.6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/caTools_1.17.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/bitops_1.0-6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/digest_0.6.15.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/glue_1.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stringr_1.3.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/markdown_0.8.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/highr_0.6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/formatR_1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/evaluate_0.10.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mime_0.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stringi_1.1.7.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/magrittr_1.5.tar.gz


RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   bitops_1.0-6.tar.gz \
   caTools_1.17.1.tar.gz \
   digest_0.6.15.tar.gz \
   Rcpp_0.12.16.tar.gz \
   htmltools_0.3.6.tar.gz \
   yaml_2.1.18.tar.gz \
   stringi_1.1.7.tar.gz \
   magrittr_1.5.tar.gz \
   mime_0.5.tar.gz \
   glue_1.2.0.tar.gz \
   stringr_1.3.0.tar.gz \
   highr_0.6.tar.gz \
   formatR_1.5.tar.gz \
   evaluate_0.10.1.tar.gz \
   markdown_0.8.tar.gz \
   knitr_1.20.tar.gz
 

RUN rm \
   evaluate_0.10.1.tar.gz \
   formatR_1.5.tar.gz \
   highr_0.6.tar.gz \
   markdown_0.8.tar.gz \
   stringi_1.1.7.tar.gz \
   magrittr_1.5.tar.gz \
   glue_1.2.0.tar.gz \
   stringr_1.3.0.tar.gz \
   knitr_1.20.tar.gz \
   yaml_2.1.18.tar.gz \
   Rcpp_0.12.16.tar.gz \
   htmltools_0.3.6.tar.gz \
   caTools_1.17.1.tar.gz \
   bitops_1.0-6.tar.gz \
   digest_0.6.15.tar.gz \
   mime_0.5.tar.gz

# dependency for R XML library
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
   libxml2 \ 
   libxml2-dev \
   libssl-dev


# R packages we need for devtools - and we need devtools to be able to update the rmarkdown package
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/rstudioapi_0.7.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/openssl_1.0.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/withr_2.1.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/brew_1.0-6.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stringi_1.1.7.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/magrittr_1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stringr_1.3.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/Archive/roxygen2/roxygen2_5.0.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rversions_1.0.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/git2r_0.21.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/devtools_1.13.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/R6_2.2.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mime_0.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/httr_1.3.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/RCurl_1.95-4.10.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/Rcpp_0.12.16.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/BH_1.66.0-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/xml2_1.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/curl_3.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/jsonlite_1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/digest_0.6.15.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/downloader_0.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/memoise_1.1.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/plyr_1.8.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/XML_3.98-1.11.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/whisker_0.3-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/bitops_1.0-6.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   jsonlite_1.5.tar.gz \
   digest_0.6.15.tar.gz \
   memoise_1.1.0.tar.gz \
   whisker_0.3-2.tar.gz \
   bitops_1.0-6.tar.gz \
   RCurl_1.95-4.10.tar.gz \
   Rcpp_0.12.16.tar.gz \
   plyr_1.8.4.tar.gz \
   R6_2.2.2.tar.gz \
   curl_3.2.tar.gz \
   openssl_1.0.1.tar.gz \
   mime_0.5.tar.gz \
   httr_1.3.1.tar.gz \
   rstudioapi_0.7.tar.gz \
   withr_2.1.2.tar.gz \
   git2r_0.21.0.tar.gz \
   devtools_1.13.5.tar.gz \
   brew_1.0-6.tar.gz \
   stringi_1.1.7.tar.gz \
   magrittr_1.5.tar.gz \
   stringr_1.3.0.tar.gz \
   roxygen2_5.0.1.tar.gz \
   XML_3.98-1.11.tar.gz \
   BH_1.66.0-1.tar.gz \
   xml2_1.2.0.tar.gz \
   rversions_1.0.3.tar.gz \
   downloader_0.4.tar.gz

RUN rm \
   jsonlite_1.5.tar.gz \
   digest_0.6.15.tar.gz \
   memoise_1.1.0.tar.gz \
   whisker_0.3-2.tar.gz \
   bitops_1.0-6.tar.gz \
   RCurl_1.95-4.10.tar.gz \
   Rcpp_0.12.16.tar.gz \
   plyr_1.8.4.tar.gz \
   R6_2.2.2.tar.gz \
   mime_0.5.tar.gz \
   httr_1.3.1.tar.gz \
   rstudioapi_0.7.tar.gz \
   openssl_1.0.1.tar.gz \
   withr_2.1.2.tar.gz \
   brew_1.0-6.tar.gz \
   stringi_1.1.7.tar.gz \
   magrittr_1.5.tar.gz \
   stringr_1.3.0.tar.gz \
   roxygen2_5.0.1.tar.gz \
   BH_1.66.0-1.tar.gz \
   XML_3.98-1.11.tar.gz \
   xml2_1.2.0.tar.gz \
   curl_3.2.tar.gz \
   rversions_1.0.3.tar.gz \
   git2r_0.21.0.tar.gz \
   devtools_1.13.5.tar.gz \
   downloader_0.4.tar.gz


# the CRAN install from source fails because a server at MIT will not respond
# maybe e can use the Ubuntu distro
#    https://mirrors.nics.utk.edu/cran/src/contrib/nloptr_1.0.4.tar.gz \
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
   r-cran-nloptr


# libraries Eric Green wanted
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/lubridate_1.7.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/assertthat_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/lazyeval_0.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rlang_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/cli_1.0.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/utf8_1.1.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/crayon_1.3.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/pillar_1.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/tibble_1.4.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/ggplot2_2.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/RColorBrewer_1.1-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/dichromat_2.0-0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/colorspace_1.3-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/munsell_0.4.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/labeling_0.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/viridisLite_0.3.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/scales_0.5.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/stargazer_5.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/reshape2_1.4.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/gtable_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/proto_1.0.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/minqa_1.2.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/RcppEigen_0.3.3.4.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/lme4_1.1-17.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   lubridate_1.7.4.tar.gz  \
   gtable_0.2.0.tar.gz \
   RColorBrewer_1.1-2.tar.gz \
   dichromat_2.0-0.tar.gz \
   colorspace_1.3-2.tar.gz \
   munsell_0.4.3.tar.gz \
   labeling_0.3.tar.gz \
   viridisLite_0.3.0.tar.gz \
   scales_0.5.0.tar.gz \
   proto_1.0.0.tar.gz \
   reshape2_1.4.3.tar.gz \
   assertthat_0.2.0.tar.gz \
   lazyeval_0.2.1.tar.gz \
   rlang_0.2.0.tar.gz \
   utf8_1.1.3.tar.gz \
   crayon_1.3.4.tar.gz \
   cli_1.0.0.tar.gz \
   pillar_1.2.1.tar.gz \
   tibble_1.4.2.tar.gz \
   ggplot2_2.2.1.tar.gz \
   stargazer_5.2.1.tar.gz \
   minqa_1.2.4.tar.gz \
   RcppEigen_0.3.3.4.0.tar.gz \
   lme4_1.1-17.tar.gz

RUN rm \
   lubridate_1.7.4.tar.gz  \
   gtable_0.2.0.tar.gz \
   RColorBrewer_1.1-2.tar.gz \
   dichromat_2.0-0.tar.gz \
   colorspace_1.3-2.tar.gz \
   munsell_0.4.3.tar.gz \
   labeling_0.3.tar.gz \
   viridisLite_0.3.0.tar.gz \
   scales_0.5.0.tar.gz \
   proto_1.0.0.tar.gz \
   reshape2_1.4.3.tar.gz \
   assertthat_0.2.0.tar.gz \
   lazyeval_0.2.1.tar.gz \
   rlang_0.2.0.tar.gz \
   cli_1.0.0.tar.gz \
   utf8_1.1.3.tar.gz \
   crayon_1.3.4.tar.gz \
   pillar_1.2.1.tar.gz \
   tibble_1.4.2.tar.gz \
   ggplot2_2.2.1.tar.gz \
   stargazer_5.2.1.tar.gz \
   minqa_1.2.4.tar.gz \
   RcppEigen_0.3.3.4.0.tar.gz \
   lme4_1.1-17.tar.gz
  
# more libraries Mine Cetinakya-Rundel asked for
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/openintro_1.7.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/tibble_1.4.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/bindr_0.1.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/bindrcpp_0.2.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/glue_1.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/pkgconfig_2.0.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/plogr_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/dplyr_0.7.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/assertthat_0.2.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/R6_2.2.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/magrittr_1.5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/lazyeval_0.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/DBI_0.8.tar.gz 



RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   openintro_1.7.1.tar.gz \
   assertthat_0.2.0.tar.gz \
   R6_2.2.2.tar.gz \
   magrittr_1.5.tar.gz \
   lazyeval_0.2.1.tar.gz \
   DBI_0.8.tar.gz \
   tibble_1.4.2.tar.gz \
   glue_1.2.0.tar.gz \
   pkgconfig_2.0.1.tar.gz \
   plogr_0.2.0.tar.gz \
   bindr_0.1.1.tar.gz \
   bindrcpp_0.2.2.tar.gz \
   dplyr_0.7.4.tar.gz 

RUN rm \
   openintro_1.7.1.tar.gz \
   assertthat_0.2.0.tar.gz \
   R6_2.2.2.tar.gz \
   magrittr_1.5.tar.gz \
   lazyeval_0.2.1.tar.gz \
   DBI_0.8.tar.gz \
   tibble_1.4.2.tar.gz \
   bindr_0.1.1.tar.gz \
   bindrcpp_0.2.2.tar.gz \
   glue_1.2.0.tar.gz \
   pkgconfig_2.0.1.tar.gz \
   plogr_0.2.0.tar.gz \
   dplyr_0.7.4.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/chron_2.3-52.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/data.table_1.10.4-3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rematch_1.0.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/cellranger_1.1.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/tidyr_0.8.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/googlesheets_0.2.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/hms_0.4.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/readr_1.1.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/purrr_0.2.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/tidyselect_0.2.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/selectr_0.4-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rvest_0.3.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/pbkrtest_0.4-7.tar.gz 
	
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   chron_2.3-52.tar.gz \
   data.table_1.10.4-3.tar.gz \
   rematch_1.0.1.tar.gz \
   cellranger_1.1.0.tar.gz \
   purrr_0.2.4.tar.gz \
   tidyselect_0.2.4.tar.gz \
   tidyr_0.8.0.tar.gz \
   hms_0.4.2.tar.gz \
   readr_1.1.1.tar.gz \
   googlesheets_0.2.2.tar.gz \
   selectr_0.4-1.tar.gz \
   rvest_0.3.2.tar.gz \
   pbkrtest_0.4-7.tar.gz 

RUN rm \
   chron_2.3-52.tar.gz \
   data.table_1.10.4-3.tar.gz \
   rematch_1.0.1.tar.gz \
   cellranger_1.1.0.tar.gz \
   tidyr_0.8.0.tar.gz \
   googlesheets_0.2.2.tar.gz \
   hms_0.4.2.tar.gz \
   readr_1.1.1.tar.gz \
   purrr_0.2.4.tar.gz \
   tidyselect_0.2.4.tar.gz \
   selectr_0.4-1.tar.gz \
   rvest_0.3.2.tar.gz \
   pbkrtest_0.4-7.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/SparseM_1.77.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/MatrixModels_0.4-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/quantreg_5.35.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/sp_1.2-7.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/maptools_0.9-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/haven_1.1.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/forcats_0.3.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/readxl_1.1.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/openxlsx_4.0.17.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rio_0.5.10.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/abind_1.4-5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/carData_3.0-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/car_3.0-0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mosaicData_0.16.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/latticeExtra_0.6-28.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/gridExtra_2.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/ggdendro_0.1-20.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mnormt_1.5-5.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/psych_1.8.3.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/broom_0.4.4.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/reshape_0.8.7.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/prettyunits_1.0.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/progress_1.1.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/GGally_1.3.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/ggformula_0.6.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mosaicCore_0.4.2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/mosaic_1.1.1.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   SparseM_1.77.tar.gz \
   MatrixModels_0.4-1.tar.gz \
   quantreg_5.35.tar.gz \
   sp_1.2-7.tar.gz \
   maptools_0.9-2.tar.gz \
   forcats_0.3.0.tar.gz \
   haven_1.1.1.tar.gz \
   readxl_1.1.0.tar.gz \
   openxlsx_4.0.17.tar.gz \
   rio_0.5.10.tar.gz \
   abind_1.4-5.tar.gz \
   carData_3.0-1.tar.gz \
   car_3.0-0.tar.gz \
   mosaicData_0.16.0.tar.gz \
   latticeExtra_0.6-28.tar.gz \
   gridExtra_2.3.tar.gz \
   ggdendro_0.1-20.tar.gz \
   mnormt_1.5-5.tar.gz \
   psych_1.8.3.3.tar.gz \
   broom_0.4.4.tar.gz \
   reshape_0.8.7.tar.gz \
   prettyunits_1.0.2.tar.gz \
   progress_1.1.2.tar.gz \
   GGally_1.3.2.tar.gz \
   mosaicCore_0.4.2.tar.gz \
   ggformula_0.6.2.tar.gz \
   mosaic_1.1.1.tar.gz 

RUN rm \
   SparseM_1.77.tar.gz \
   MatrixModels_0.4-1.tar.gz \
   quantreg_5.35.tar.gz \
   sp_1.2-7.tar.gz \
   maptools_0.9-2.tar.gz \
   forcats_0.3.0.tar.gz \
   haven_1.1.1.tar.gz \
   readxl_1.1.0.tar.gz \
   openxlsx_4.0.17.tar.gz \
   rio_0.5.10.tar.gz \
   abind_1.4-5.tar.gz \
   carData_3.0-1.tar.gz \
   car_3.0-0.tar.gz \
   mosaicData_0.16.0.tar.gz \
   latticeExtra_0.6-28.tar.gz \
   gridExtra_2.3.tar.gz \
   ggdendro_0.1-20.tar.gz \
   mnormt_1.5-5.tar.gz \
   psych_1.8.3.3.tar.gz \
   broom_0.4.4.tar.gz \
   reshape_0.8.7.tar.gz \
   prettyunits_1.0.2.tar.gz \
   progress_1.1.2.tar.gz \
   GGally_1.3.2.tar.gz \
   mosaicCore_0.4.2.tar.gz \
   ggformula_0.6.2.tar.gz \
   mosaic_1.1.1.tar.gz 

# Cliburn Chan requested these:
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/RColorBrewer_1.1-2.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/maps_3.3.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/zoo_1.8-1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/gcookbook_1.0.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/corrplot_0.84.tar.gz 


RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   RColorBrewer_1.1-2.tar.gz \
   maps_3.3.0.tar.gz \
   zoo_1.8-1.tar.gz \
   gcookbook_1.0.tar.gz \
   corrplot_0.84.tar.gz 


RUN rm \
   RColorBrewer_1.1-2.tar.gz \
   maps_3.3.0.tar.gz \
   zoo_1.8-1.tar.gz \
   gcookbook_1.0.tar.gz \
   corrplot_0.84.tar.gz 
   

# install rmarkdown
ADD ./conf /r-studio
RUN R CMD BATCH /r-studio/install-rmarkdown.R
RUN rm /install-rmarkdown.Rout 

# Cliburn also wanted these
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


# install sparklyr so we can do Spark via Livy
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/config_0.3.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/dbplyr_1.2.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rappdirs_0.3.1.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/sparklyr_0.7.0.tar.gz
   
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   config_0.3.tar.gz \
   dbplyr_1.2.1.tar.gz \
   rappdirs_0.3.1.tar.gz \
   sparklyr_0.7.0.tar.gz
   
RUN rm \
  config_0.3.tar.gz \
  dbplyr_1.2.1.tar.gz \
  rappdirs_0.3.1.tar.gz \
  sparklyr_0.7.0.tar.gz


# some more TeX so that papaja can be installed and students can create APA templates in Rmarkdown
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
   texlive \
   texlive-publishers \
   texlive-fonts-extra \
   texlive-latex-extra \
   texlive-humanities \
   lmodern 
# papaja
RUN R CMD BATCH /r-studio/install-papaja.R


# install templates and examples from Reed and the Tufte package
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/BHH2_2016.05.31.tar.gz
   
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   BHH2_2016.05.31.tar.gz
   
RUN rm \
  BHH2_2016.05.31.tar.gz
  
RUN R CMD BATCH /r-studio/install-reed.R
RUN rm /install-reed.Rout 


# a couple dependencies for Eric Greene's tidycensus
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
	libproj-dev \
	libudunits2-0 \
	libudunits2-dev \
	software-properties-common
 
# we need gdal > 2
RUN  add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
RUN  apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get  install -y \
    gdal-bin \
    python-gdal \
    libgdal-dev

	
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://mirrors.nics.utk.edu/cran/src/contrib/rgdal_1.2-18.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/rgeos_0.3-26.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/sp_1.2-7.tar.gz \
   https://mirrors.nics.utk.edu/cran/src/contrib/uuid_0.1-2.tar.gz
 
 
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   sp_1.2-7.tar.gz  \
   rgdal_1.2-18.tar.gz \
   rgeos_0.3-26.tar.gz \
   uuid_0.1-2.tar.gz 

RUN rm \
   sp_1.2-7.tar.gz \
   rgdal_1.2-18.tar.gz \
   rgeos_0.3-26.tar.gz \
   uuid_0.1-2.tar.gz

RUN R CMD BATCH /r-studio/install-rappdirs.R
RUN rm /install-rappdirs.Rout 

RUN DEBIAN_FRONTEND=noninteractive wget \
    https://mirrors.nics.utk.edu/cran/src/contrib/tigris_0.7.tar.gz \
    https://mirrors.nics.utk.edu/cran/src/contrib/tidycensus_0.4.6.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
    tigris_0.7.tar.gz \
    tidycensus_0.4.6.tar.gz 

RUN rm \
    tigris_0.7.tar.gz  \
    tidycensus_0.4.6.tar.gz 
	
	
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
