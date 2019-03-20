# mccahill/r-studio
#
# VERSION 1.4

FROM ubuntu:18.04
MAINTAINER Mark McCahill "mark.mccahill@duke.edu"

RUN apt-get  update ; \
    apt-get  install gnupg2 -y
	
# get R from a CRAN archive (we want the 3.5 version of R)
RUN echo  "deb http://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/"  >>  /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-key adv  --keyserver keyserver.ubuntu.com --recv-keys  E084DAB9

RUN apt-get  update ; \
    apt-get  dist-upgrade -y 

# we want OpenBLAS for faster linear algebra as described here: http://brettklamer.com/diversions/statistical/faster-blas-in-r/
RUN apt-get install  -y \
   apt-utils \
   libopenblas-base

RUN apt-get update ; \
   DEBIAN_FRONTEND=noninteractive apt-get  install -y  \
   r-base \
   r-base-dev \
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
   sudo 

RUN apt-get update ; \
   DEBIAN_FRONTEND=noninteractive apt-get  install -y \
   libcurl4-gnutls-dev \
   libgit2-dev \
   libxml2-dev \
   libssl-dev \
   libudunits2-dev \
   libpoppler-cpp-dev


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
   
# RUN DEBIAN_FRONTEND=noninteractive wget https://download2.rstudio.org/rstudio-server-1.1.383-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive wget https://s3.amazonaws.com/rstudio-ide-build/server/trusty/amd64/rstudio-server-1.2.907-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi --n rstudio-server-1.2.907-amd64.deb
RUN rm rstudio-server-1.2.907-amd64.deb

# update the R packages we will need for knitr
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/xfun_0.5.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/knitr_1.22.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/yaml_2.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/Rcpp_1.0.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/htmltools_0.3.6.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/caTools_1.17.1.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/bitops_1.0-6.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/digest_0.6.18.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/glue_1.3.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/stringr_1.4.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/markdown_0.9.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/highr_0.7.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/formatR_1.6.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/evaluate_0.13.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/mime_0.6.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/stringi_1.4.3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/magrittr_1.5.tar.gz


RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   bitops_1.0-6.tar.gz \
   caTools_1.17.1.2.tar.gz \
   digest_0.6.18.tar.gz \
   Rcpp_1.0.1.tar.gz \
   htmltools_0.3.6.tar.gz \
   yaml_2.2.0.tar.gz \
   stringi_1.4.3.tar.gz \
   magrittr_1.5.tar.gz \
   mime_0.6.tar.gz \
   glue_1.3.1.tar.gz \
   stringr_1.4.0.tar.gz \
   highr_0.7.tar.gz \
   formatR_1.6.tar.gz \
   evaluate_0.13.tar.gz \
   markdown_0.9.tar.gz \
   xfun_0.5.tar.gz \
   knitr_1.22.tar.gz
 

RUN rm \
   evaluate_0.13.tar.gz \
   formatR_1.6.tar.gz \
   highr_0.7.tar.gz \
   markdown_0.9.tar.gz \
   stringi_1.4.3.tar.gz \
   magrittr_1.5.tar.gz \
   glue_1.3.1.tar.gz \
   stringr_1.4.0.tar.gz \
   xfun_0.5.tar.gz \
   knitr_1.22.tar.gz \
   yaml_2.2.0.tar.gz \
   Rcpp_1.0.1.tar.gz \
   htmltools_0.3.6.tar.gz \
   caTools_1.17.1.2.tar.gz \
   bitops_1.0-6.tar.gz \
   digest_0.6.18.tar.gz \
   mime_0.6.tar.gz

# dependency for R XML library
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
   libxml2 \ 
   libxml2-dev \
   libssl-dev


# R packages we need for devtools - and we need devtools to be able to update the rmarkdown package
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/processx_3.3.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/ps_1.3.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/callr_3.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/crayon_1.3.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/assertthat_0.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/cli_1.1.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/desc_1.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/prettyunits_1.0.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/backports_1.1.3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rprojroot_1.3-2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/withr_2.1.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/pkgbuild_1.0.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rlang_0.3.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rstudioapi_0.10.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/pkgload_1.0.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rcmdcheck_1.3.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/remotes_2.0.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/xopen_1.0.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/clipr_0.5.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/clisymbols_1.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/sessioninfo_1.1.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/usethis_1.4.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/sys_3.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/askpass_1.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/openssl_1.2.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/brew_1.0-6.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/Archive/roxygen2/roxygen2_5.0.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/fs_1.2.7.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/gh_1.0.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rversions_1.0.3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/git2r_0.25.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/devtools_2.0.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/R6_2.4.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/httr_1.4.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/RCurl_1.95-4.12.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/BH_1.69.0-1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/xml2_1.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/curl_3.3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/jsonlite_1.6.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/ini_0.3.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/downloader_0.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/memoise_1.1.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/plyr_1.8.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/XML_3.98-1.19.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/whisker_0.3-2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/bitops_1.0-6.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   ps_1.3.0.tar.gz \
   R6_2.4.0.tar.gz \
   processx_3.3.0.tar.gz \
   callr_3.2.0.tar.gz \
   crayon_1.3.4.tar.gz \
   assertthat_0.2.0.tar.gz \
   cli_1.1.0.tar.gz \
   backports_1.1.3.tar.gz \
   rprojroot_1.3-2.tar.gz \
   desc_1.2.0.tar.gz \
   prettyunits_1.0.2.tar.gz \
   withr_2.1.2.tar.gz \
   pkgbuild_1.0.2.tar.gz \
   rlang_0.3.1.tar.gz \
   rstudioapi_0.10.tar.gz \
   pkgload_1.0.2.tar.gz \
   xopen_1.0.0.tar.gz \
   sessioninfo_1.1.1.tar.gz \
   rcmdcheck_1.3.2.tar.gz \
   remotes_2.0.2.tar.gz \   
   whisker_0.3-2.tar.gz \
   git2r_0.25.2.tar.gz \
   fs_1.2.7.tar.gz \
   ini_0.3.1.tar.gz \
   jsonlite_1.6.tar.gz \
   sys_3.1.tar.gz \
   askpass_1.1.tar.gz \
   openssl_1.2.2.tar.gz \
   curl_3.3.tar.gz \
   httr_1.4.0.tar.gz \
   gh_1.0.1.tar.gz \
   clipr_0.5.0.tar.gz \
   clisymbols_1.2.0.tar.gz \   
   usethis_1.4.0.tar.gz \
   memoise_1.1.0.tar.gz \
   bitops_1.0-6.tar.gz \
   RCurl_1.95-4.12.tar.gz \
   plyr_1.8.4.tar.gz \
   devtools_2.0.1.tar.gz \
   brew_1.0-6.tar.gz \
   roxygen2_5.0.1.tar.gz \
   XML_3.98-1.19.tar.gz \
   BH_1.69.0-1.tar.gz \
   xml2_1.2.0.tar.gz \
   rversions_1.0.3.tar.gz \
   downloader_0.4.tar.gz

RUN rm \
   ps_1.3.0.tar.gz \
   callr_3.2.0.tar.gz \
   R6_2.4.0.tar.gz \
   processx_3.3.0.tar.gz \
   crayon_1.3.4.tar.gz \
   assertthat_0.2.0.tar.gz \
   cli_1.1.0.tar.gz \
   desc_1.2.0.tar.gz \
   prettyunits_1.0.2.tar.gz \
   backports_1.1.3.tar.gz \
   rprojroot_1.3-2.tar.gz \
   withr_2.1.2.tar.gz \
   pkgbuild_1.0.2.tar.gz \
   rlang_0.3.1.tar.gz \
   rstudioapi_0.10.tar.gz \
   clipr_0.5.0.tar.gz \
   clisymbols_1.2.0.tar.gz \
   pkgload_1.0.2.tar.gz \
   sessioninfo_1.1.1.tar.gz \
   xopen_1.0.0.tar.gz \
   rcmdcheck_1.3.2.tar.gz \
   remotes_2.0.2.tar.gz \
   usethis_1.4.0.tar.gz \
   ini_0.3.1.tar.gz \
   jsonlite_1.6.tar.gz \
   memoise_1.1.0.tar.gz \
   whisker_0.3-2.tar.gz \
   bitops_1.0-6.tar.gz \
   RCurl_1.95-4.12.tar.gz \
   plyr_1.8.4.tar.gz \
   httr_1.4.0.tar.gz \
   sys_3.1.tar.gz \
   askpass_1.1.tar.gz \
   openssl_1.2.2.tar.gz \
   brew_1.0-6.tar.gz \
   roxygen2_5.0.1.tar.gz \
   BH_1.69.0-1.tar.gz \
   XML_3.98-1.19.tar.gz \
   xml2_1.2.0.tar.gz \
   curl_3.3.tar.gz \
   rversions_1.0.3.tar.gz \
   git2r_0.25.2.tar.gz \
   devtools_2.0.1.tar.gz \
   downloader_0.4.tar.gz

# the CRAN install from source fails because a server at MIT will not respond
# install from source
ADD ./conf /r-studio
#RUN R CMD BATCH /r-studio/install-nloptr.R
#RUN rm /install-nloptr.Rout

RUN DEBIAN_FRONTEND=noninteractive wget \
    https://archive.linux.duke.edu/cran/src/contrib/nloptr_1.2.1.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
    nloptr_1.2.1.tar.gz

RUN rm \
    nloptr_1.2.1.tar.gz


# libraries Eric Green wanted
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/lubridate_1.7.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/lazyeval_0.2.20.2.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/utf8_1.1.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/fansi_0.4.00.3.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/pillar_1.3.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/tibble_1.4.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/ggplot2_3.1.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/RColorBrewer_1.1-2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/dichromat_2.0-0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/colorspace_1.4-1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/munsell_0.5.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/labeling_0.3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/viridisLite_0.3.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/scales_1.0.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/stargazer_5.2.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/reshape2_1.4.3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/gtable_0.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/proto_1.0.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/minqa_1.2.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/RcppEigen_0.3.3.5.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/lme4_1.1-21.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   lubridate_1.7.4.tar.gz  \
   gtable_0.2.0.tar.gz \
   RColorBrewer_1.1-2.tar.gz \
   dichromat_2.0-0.tar.gz \
   colorspace_1.4-1.tar.gz \
   munsell_0.5.0.tar.gz \
   labeling_0.3.tar.gz \
   viridisLite_0.3.0.tar.gz \
   scales_1.0.0.tar.gz \
   proto_1.0.0.tar.gz \
   reshape2_1.4.3.tar.gz \
   lazyeval_0.2.20.2.1.tar.gz \
   utf8_1.1.4.tar.gz \
   fansi_0.4.00.3.0.tar.gz \
   pillar_1.3.1.tar.gz \
   tibble_1.4.2.tar.gz \
   ggplot2_3.1.0.tar.gz \
   stargazer_5.2.2.tar.gz \
   minqa_1.2.4.tar.gz \
   RcppEigen_0.3.3.5.0.tar.gz0.3.3.4.0.tar.gz \
   lme4_1.1-21.tar.gz

RUN rm \
   lubridate_1.7.4.tar.gz  \
   gtable_0.2.0.tar.gz \
   RColorBrewer_1.1-2.tar.gz \
   dichromat_2.0-0.tar.gz \
   colorspace_1.4-1.tar.gz \
   munsell_0.5.0.tar.gz \
   labeling_0.3.tar.gz \
   viridisLite_0.3.0.tar.gz \
   scales_1.0.0.tar.gz \
   proto_1.0.0.tar.gz \
   reshape2_1.4.3.tar.gz \
   lazyeval_0.2.20.2.1.tar.gz \
   utf8_1.1.4.tar.gz \
   fansi_0.4.00.3.0.tar.gz \
   pillar_1.3.1.tar.gz \
   tibble_1.4.2.tar.gz \
   ggplot2_3.1.0.tar.gz \
   stargazer_5.2.2.tar.gz \
   minqa_1.2.4.tar.gz \
   RcppEigen_0.3.3.5.0.tar.gz0.3.3.4.0.tar.gz \
   lme4_1.1-21.tar.gz
  
# more libraries Mine Cetinakya-Rundel asked for
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/openintro_1.7.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/bindr_0.1.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/bindrcpp_0.2.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/pkgconfig_2.0.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/plogr_0.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/purrr_0.2.5.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/tidyselect_0.2.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/dplyr_0.7.6.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/assertthat_0.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/DBI_1.0.0.tar.gz 



RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   openintro_1.7.1.tar.gz \
   assertthat_0.2.0.tar.gz \
   DBI_1.0.0.tar.gz \
   pkgconfig_2.0.2.tar.gz \
   plogr_0.2.0.tar.gz \
   bindr_0.1.1.tar.gz \
   bindrcpp_0.2.2.tar.gz \
   purrr_0.2.5.tar.gz \
   tidyselect_0.2.4.tar.gz \
   dplyr_0.7.6.tar.gz 

RUN rm \
   openintro_1.7.1.tar.gz \
   assertthat_0.2.0.tar.gz \
   DBI_1.0.0.tar.gz \
   bindr_0.1.1.tar.gz \
   bindrcpp_0.2.2.tar.gz \
   pkgconfig_2.0.2.tar.gz \
   plogr_0.2.0.tar.gz \
   purrr_0.2.5.tar.gz \
   tidyselect_0.2.4.tar.gz \
   dplyr_0.7.6.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/chron_2.3-52.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/data.table_1.11.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rematch_1.0.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/cellranger_1.1.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/tidyr_0.8.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/googlesheets_0.3.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/hms_0.4.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/readr_1.1.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/selectr_0.4-1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rvest_0.3.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/pbkrtest_0.4-7.tar.gz 
	
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   chron_2.3-52.tar.gz \
   data.table_1.11.4.tar.gz \
   rematch_1.0.1.tar.gz \
   cellranger_1.1.0.tar.gz \
   tidyr_0.8.1.tar.gz \
   hms_0.4.2.tar.gz \
   readr_1.1.1.tar.gz \
   googlesheets_0.3.0.tar.gz \
   selectr_0.4-1.tar.gz \
   rvest_0.3.2.tar.gz \
   pbkrtest_0.4-7.tar.gz 

RUN rm \
   chron_2.3-52.tar.gz \
   data.table_1.11.4.tar.gz \
   rematch_1.0.1.tar.gz \
   cellranger_1.1.0.tar.gz \
   tidyr_0.8.1.tar.gz \
   googlesheets_0.3.0.tar.gz \
   hms_0.4.2.tar.gz \
   readr_1.1.1.tar.gz \
   selectr_0.4-1.tar.gz \
   rvest_0.3.2.tar.gz \
   pbkrtest_0.4-7.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/SparseM_1.77.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/MatrixModels_0.4-1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/quantreg_5.36.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/sp_1.3-1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/maptools_0.9-3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/haven_1.1.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/forcats_0.3.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/readxl_1.1.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/zip_1.0.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/openxlsx_4.1.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rio_0.5.10.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/abind_1.4-5.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/carData_3.0-1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/car_3.0-2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/mosaicData_0.17.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/latticeExtra_0.6-28.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/gridExtra_2.3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/ggdendro_0.1-20.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/mnormt_1.5-5.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/psych_1.8.4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/broom_0.5.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/reshape_0.8.7.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/progress_1.2.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/GGally_1.4.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/ggstance_0.3.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/ggformula_0.9.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/mosaicCore_0.6.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/ggrepel_0.8.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/mosaic_1.4.0.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   SparseM_1.77.tar.gz \
   MatrixModels_0.4-1.tar.gz \
   quantreg_5.36.tar.gz \
   sp_1.3-1.tar.gz \
   maptools_0.9-3.tar.gz \
   forcats_0.3.0.tar.gz \
   haven_1.1.2.tar.gz \
   readxl_1.1.0.tar.gz \
   zip_1.0.0.tar.gz \
   openxlsx_4.1.0.tar.gz \
   rio_0.5.10.tar.gz \
   abind_1.4-5.tar.gz \
   carData_3.0-1.tar.gz \
   car_3.0-2.tar.gz \
   mosaicData_0.17.0.tar.gz \
   latticeExtra_0.6-28.tar.gz \
   gridExtra_2.3.tar.gz \
   ggdendro_0.1-20.tar.gz \
   mnormt_1.5-5.tar.gz \
   psych_1.8.4.tar.gz \
   broom_0.5.0.tar.gz \
   reshape_0.8.7.tar.gz \
   progress_1.2.0.tar.gz \
   GGally_1.4.0.tar.gz \
   mosaicCore_0.6.0.tar.gz \
   ggstance_0.3.1.tar.gz \
   ggformula_0.9.0.tar.gz \
   ggrepel_0.8.0.tar.gz \
   mosaic_1.4.0.tar.gz 

RUN rm \
   SparseM_1.77.tar.gz \
   MatrixModels_0.4-1.tar.gz \
   quantreg_5.36.tar.gz \
   sp_1.3-1.tar.gz \
   maptools_0.9-3.tar.gz \
   forcats_0.3.0.tar.gz \
   haven_1.1.2.tar.gz \
   readxl_1.1.0.tar.gz \
   zip_1.0.0.tar.gz \
   openxlsx_4.1.0.tar.gz \
   rio_0.5.10.tar.gz \
   abind_1.4-5.tar.gz \
   carData_3.0-1.tar.gz \
   car_3.0-2.tar.gz \
   mosaicData_0.17.0.tar.gz \
   latticeExtra_0.6-28.tar.gz \
   gridExtra_2.3.tar.gz \
   ggdendro_0.1-20.tar.gz \
   mnormt_1.5-5.tar.gz \
   psych_1.8.4.tar.gz \
   broom_0.5.0.tar.gz \
   reshape_0.8.7.tar.gz \
   progress_1.2.0.tar.gz \
   GGally_1.4.0.tar.gz \
   mosaicCore_0.6.0.tar.gz \
   ggstance_0.3.1.tar.gz \
   ggformula_0.9.0.tar.gz \
   ggrepel_0.8.0.tar.gz \
   mosaic_1.4.0.tar.gz 

# Cliburn Chan requested these:
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/RColorBrewer_1.1-2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/maps_3.3.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/zoo_1.8-3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/gcookbook_1.0.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/corrplot_0.84.tar.gz 


RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   RColorBrewer_1.1-2.tar.gz \
   maps_3.3.0.tar.gz \
   zoo_1.8-3.tar.gz \
   gcookbook_1.0.tar.gz \
   corrplot_0.84.tar.gz 


RUN rm \
   RColorBrewer_1.1-2.tar.gz \
   maps_3.3.0.tar.gz \
   zoo_1.8-3.tar.gz \
   gcookbook_1.0.tar.gz \
   corrplot_0.84.tar.gz 
   

# install rmarkdown
RUN R CMD BATCH /r-studio/install-rmarkdown.R
RUN rm /install-rmarkdown.Rout 

# Cliburn also wanted these
# but they have mega-dependencies, so intall them the other way
RUN R CMD BATCH /r-studio/install-dendextend.R
RUN rm /install-dendextend.Rout 
RUN R CMD BATCH /r-studio/install-igraph.R
RUN rm /install-igraph.Rout 

# Shiny
#RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.3.838-amd64.deb
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi -n shiny-server-1.5.7.907-amd64.deb
RUN rm shiny-server-1.5.7.907-amd64.deb
RUN R CMD BATCH /r-studio/install-Shiny.R
RUN rm /install-Shiny.Rout

# install sparklyr so we can do Spark via Livy
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/config_0.3.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/dbplyr_1.2.2.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rappdirs_0.3.1.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/sparklyr_0.8.4.tar.gz
   
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   config_0.3.tar.gz \
   dbplyr_1.2.2.tar.gz \
   rappdirs_0.3.1.tar.gz \
   sparklyr_0.8.4.tar.gz
   
RUN rm \
  config_0.3.tar.gz \
  dbplyr_1.2.2.tar.gz \
  rappdirs_0.3.1.tar.gz \
  sparklyr_0.8.4.tar.gz


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
RUN rm /install-papaja.Rout

# install templates and examples from Reed and the Tufte package
RUN DEBIAN_FRONTEND=noninteractive wget \
   https://archive.linux.duke.edu/cran/src/contrib/BHH2_2016.05.31.tar.gz
   
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
   https://archive.linux.duke.edu/cran/src/contrib/rgdal_1.3-4.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/rgeos_0.3-28.tar.gz \
   https://archive.linux.duke.edu/cran/src/contrib/uuid_0.1-2.tar.gz
 
 
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
   rgdal_1.3-4.tar.gz \
   rgeos_0.3-28.tar.gz \
   uuid_0.1-2.tar.gz 

RUN rm \
   rgdal_1.3-4.tar.gz \
   rgeos_0.3-28.tar.gz \
   uuid_0.1-2.tar.gz

RUN R CMD BATCH /r-studio/install-rappdirs.R
RUN rm /install-rappdirs.Rout 

RUN DEBIAN_FRONTEND=noninteractive wget \
    https://archive.linux.duke.edu/cran/src/contrib/tigris_0.7.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/tidycensus_0.8.1.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
    tigris_0.7.tar.gz \
    tidycensus_0.8.1.tar.gz 

RUN rm \
    tigris_0.7.tar.gz  \
    tidycensus_0.8.1.tar.gz 
	
# new packages for fall 2018
RUN DEBIAN_FRONTEND=noninteractive wget \
    https://archive.linux.duke.edu/cran/src/contrib/tidyverse_1.2.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/promises_1.0.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/future_1.9.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/doMC_1.3.5.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/foreach_1.4.4.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/doParallel_1.0.11.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/furrr_0.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/drat_0.1.4.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/tidygraph_1.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/here_0.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rticles_0.5.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/styler_1.0.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/lintr_1.0.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/testthat_2.0.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/reprex_0.2.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/microbenchmark_1.4-4.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/modelr_0.1.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/globals_0.12.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/listenv_0.7.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/iterators_1.0.10.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/enc_0.2.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rematch2_2.0.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rex_1.1.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/stringdist_0.9.5.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/praise_1.0.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/profmem_0.5.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/bench_1.0.1.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
    modelr_0.1.2.tar.gz \
    prex_0.2.0.tar.gz \
    tidyverse_1.2.1.tar.gz \
    promises_1.0.1.tar.gz \
    globals_0.12.2.tar.gz \
    listenv_0.7.0.tar.gz \
    future_1.9.0.tar.gz \
    iterators_1.0.10.tar.gz \
    foreach_1.4.4.tar.gz \
    doMC_1.3.5.tar.gz \
    doParallel_1.0.11.tar.gz \
    furrr_0.1.0.tar.gz \
    drat_0.1.4.tar.gz \
    tidygraph_1.1.0.tar.gz \
    here_0.1.tar.gz \
    rticles_0.5.tar.gz \
    enc_0.2.0.tar.gz \
    rematch2_2.0.1.tar.gz \
    styler_1.0.2.tar.gz \
    rex_1.1.2.tar.gz \
    stringdist_0.9.5.1.tar.gz \
    praise_1.0.0.tar.gz \
    testthat_2.0.0.tar.gz \
    lintr_1.0.2.tar.gz \
    profmem_0.5.0.tar.gz \
    microbenchmark_1.4-4.tar.gz \
    bench_1.0.1.tar.gz 

RUN rm \
    modelr_0.1.2.tar.gz \
    profmem_0.5.0.tar.gz \
    praise_1.0.0.tar.gz \
    rex_1.1.2.tar.gz \
    stringdist_0.9.5.1.tar.gz \
    enc_0.2.0.tar.gz \
    rematch2_2.0.1.tar.gz \
    globals_0.12.2.tar.gz \
    iterators_1.0.10.tar.gz \
    listenv_0.7.0.tar.gz \
    tidyverse_1.2.1.tar.gz \
    promises_1.0.1.tar.gz \
    future_1.9.0.tar.gz \
    doMC_1.3.5.tar.gz \
    foreach_1.4.4.tar.gz \
    doParallel_1.0.11.tar.gz \
    furrr_0.1.0.tar.gz \
    drat_0.1.4.tar.gz \
    tidygraph_1.1.0.tar.gz \
    here_0.1.tar.gz \
    rticles_0.5.tar.gz \
    styler_1.0.2.tar.gz \
    lintr_1.0.2.tar.gz \
    testthat_2.0.0.tar.gz \
    reprex_0.2.0.tar.gz \
    microbenchmark_1.4-4.tar.gz \
    bench_1.0.1.tar.gz 


RUN DEBIAN_FRONTEND=noninteractive wget \
    https://archive.linux.duke.edu/cran/src/contrib/pryr_0.1.4.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/htmlwidgets_1.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/profvis_0.3.5.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/RcppArmadillo_0.9.100.5.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/servr_0.10.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/xaringan_0.7.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rsconnect_0.8.8.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/PKI_0.1-5.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/RJSONIO_1.3-0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/packrat_0.4.9-3.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/highlight_0.4.7.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/pkgdown_1.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/bookdown_0.7.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/blogdown_0.8.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/cowplot_0.9.3.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/influenceR_0.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/Rook_1.1-1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rgexf_0.15.3.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/visNetwork_2.0.4.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/DiagrammeR_1.0.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/tweenr_0.1.5.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ggforce_0.1.3.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/RgoogleMaps_1.4.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/png_0.1-7.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rjson_0.2.20.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/mapproj_1.2.6.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/jpeg_0.1-8.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/geosphere_1.5-7.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ggmap_2.6.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ggraph_1.0.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/viridis_0.5.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/shiny_1.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/shinyjs_1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/flexdashboard_0.5.1.1.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
    pryr_0.1.4.tar.gz \
    htmlwidgets_1.2.tar.gz \
    profvis_0.3.5.tar.gz \
    RcppArmadillo_0.9.100.5.0.tar.gz \
    servr_0.10.tar.gz \
    xaringan_0.7.tar.gz \
    PKI_0.1-5.1.tar.gz \
    RJSONIO_1.3-0.tar.gz \
    packrat_0.4.9-3.tar.gz \
    rsconnect_0.8.8.tar.gz \
    highlight_0.4.7.2.tar.gz \
    pkgdown_1.1.0.tar.gz \
    bookdown_0.7.tar.gz \
    blogdown_0.8.tar.gz \
    cowplot_0.9.3.tar.gz \
    influenceR_0.1.0.tar.gz \
    Rook_1.1-1.tar.gz \
    rgexf_0.15.3.tar.gz \
    visNetwork_2.0.4.tar.gz \
    DiagrammeR_1.0.0.tar.gz \
    tweenr_0.1.5.tar.gz \
    ggforce_0.1.3.tar.gz \
    png_0.1-7.tar.gz \
    jpeg_0.1-8.tar.gz \
    RgoogleMaps_1.4.2.tar.gz \
    rjson_0.2.20.tar.gz \
    mapproj_1.2.6.tar.gz \
    geosphere_1.5-7.tar.gz \
    ggmap_2.6.1.tar.gz \
    viridis_0.5.1.tar.gz \
    ggraph_1.0.2.tar.gz \
    shiny_1.1.0.tar.gz \
    shinyjs_1.0.tar.gz \
    flexdashboard_0.5.1.1.tar.gz 

RUN rm \
    pryr_0.1.4.tar.gz \
    htmlwidgets_1.2.tar.gz \
    profvis_0.3.5.tar.gz \
    RcppArmadillo_0.9.100.5.0.tar.gz \
    servr_0.10.tar.gz \
    xaringan_0.7.tar.gz \
    PKI_0.1-5.1.tar.gz \
    RJSONIO_1.3-0.tar.gz \
    packrat_0.4.9-3.tar.gz \
    rsconnect_0.8.8.tar.gz \
    highlight_0.4.7.2.tar.gz \
    pkgdown_1.1.0.tar.gz \
    bookdown_0.7.tar.gz \
    blogdown_0.8.tar.gz \
    cowplot_0.9.3.tar.gz \
    influenceR_0.1.0.tar.gz \
    Rook_1.1-1.tar.gz \
    rgexf_0.15.3.tar.gz \
    visNetwork_2.0.4.tar.gz \
    DiagrammeR_1.0.0.tar.gz \
    tweenr_0.1.5.tar.gz \
    ggforce_0.1.3.tar.gz \
    RgoogleMaps_1.4.2.tar.gz \
    png_0.1-7.tar.gz \
    rjson_0.2.20.tar.gz \
    mapproj_1.2.6.tar.gz \
    jpeg_0.1-8.tar.gz \
    geosphere_1.5-7.tar.gz \
    ggmap_2.6.1.tar.gz \
    ggraph_1.0.2.tar.gz \
    viridis_0.5.1.tar.gz \
    shiny_1.1.0.tar.gz \
    shinyjs_1.0.tar.gz \
    flexdashboard_0.5.1.1.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive wget \
    https://archive.linux.duke.edu/cran/src/contrib/nycflights13_1.0.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/babynames_0.3.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/janeaustenr_0.1.5.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/NHANES_2.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/repurrrsive_0.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/infer_0.3.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ipred_0.9-7.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/numDeriv_2016.8-1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/SQUAREM_2017.10-1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/lava_1.6.3.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/prodlim_2018.04.18.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/CVST_0.2-2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/DRR_0.0.3.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/dimRed_0.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/timeDate_3043.102.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/sfsmisc_1.1-2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/magic_1.5-8.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/geometry_0.3-6.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ddalpha_1.3.4.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
    nycflights13_1.0.0.tar.gz \
    babynames_0.3.0.tar.gz \
    janeaustenr_0.1.5.tar.gz \
    NHANES_2.1.0.tar.gz \
    repurrrsive_0.1.0.tar.gz \
    infer_0.3.1.tar.gz \
    numDeriv_2016.8-1.tar.gz \
    SQUAREM_2017.10-1.tar.gz \
    lava_1.6.3.tar.gz \
    prodlim_2018.04.18.tar.gz \
    ipred_0.9-7.tar.gz \
    CVST_0.2-2.tar.gz \
    DRR_0.0.3.tar.gz \
    dimRed_0.1.0.tar.gz \
    timeDate_3043.102.tar.gz \
    sfsmisc_1.1-2.tar.gz \
    magic_1.5-8.tar.gz \
    geometry_0.3-6.tar.gz \
    ddalpha_1.3.4.tar.gz 
	
RUN rm \
    nycflights13_1.0.0.tar.gz \
    babynames_0.3.0.tar.gz \
    janeaustenr_0.1.5.tar.gz \
    NHANES_2.1.0.tar.gz \
    repurrrsive_0.1.0.tar.gz \
    infer_0.3.1.tar.gz \
    numDeriv_2016.8-1.tar.gz \
    SQUAREM_2017.10-1.tar.gz \
    lava_1.6.3.tar.gz \
    prodlim_2018.04.18.tar.gz \
    ipred_0.9-7.tar.gz \
    CVST_0.2-2.tar.gz \
    DRR_0.0.3.tar.gz \
    dimRed_0.1.0.tar.gz \
    timeDate_3043.102.tar.gz \
    sfsmisc_1.1-2.tar.gz \
    magic_1.5-8.tar.gz \
    geometry_0.3-6.tar.gz \
    ddalpha_1.3.4.tar.gz 
	
RUN DEBIAN_FRONTEND=noninteractive wget \
    https://archive.linux.duke.edu/cran/src/contrib/gower_0.1.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/RcppRoll_0.3.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/pls_2.7-0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/recipes_0.1.3.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rsample_0.0.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/hunspell_2.9.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/SnowballC_0.5.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/tokenizers_0.2.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ISOcodes_2018.06.29.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/stopwords_0.9.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/tidytext_0.1.9.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ggridges_0.5.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/bayesplot_1.6.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/matrixStats_0.54.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/loo_2.0.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/StanHeaders_2.17.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/inline_0.3.15.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rstan_2.17.3.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/rstantools_1.5.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/tidypredict_0.2.0.tar.gz 
	

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
    gower_0.1.2.tar.gz \
    RcppRoll_0.3.0.tar.gz \
    pls_2.7-0.tar.gz \
    recipes_0.1.3.tar.gz \
    rsample_0.0.2.tar.gz \
    hunspell_2.9.tar.gz \
    SnowballC_0.5.1.tar.gz \
    tokenizers_0.2.1.tar.gz \
    ISOcodes_2018.06.29.tar.gz \
    stopwords_0.9.0.tar.gz \
    tidytext_0.1.9.tar.gz \
    tidypredict_0.2.0.tar.gz \
    ggridges_0.5.0.tar.gz \
    bayesplot_1.6.0.tar.gz \
    matrixStats_0.54.0.tar.gz \
    loo_2.0.0.tar.gz \
    StanHeaders_2.17.2.tar.gz \
    inline_0.3.15.tar.gz \
    rstan_2.17.3.tar.gz \
    rstantools_1.5.1.tar.gz 
	
	
RUN rm \
    gower_0.1.2.tar.gz \
    RcppRoll_0.3.0.tar.gz \
    pls_2.7-0.tar.gz \
    recipes_0.1.3.tar.gz \
    rsample_0.0.2.tar.gz \
    hunspell_2.9.tar.gz \
    SnowballC_0.5.1.tar.gz \
    tokenizers_0.2.1.tar.gz \
    ISOcodes_2018.06.29.tar.gz \
    stopwords_0.9.0.tar.gz \
    tidytext_0.1.9.tar.gz \
    ggridges_0.5.0.tar.gz \
    bayesplot_1.6.0.tar.gz \
    matrixStats_0.54.0.tar.gz \
    loo_2.0.0.tar.gz \
    StanHeaders_2.17.2.tar.gz \
    inline_0.3.15.tar.gz \
    rstan_2.17.3.tar.gz \
    rstantools_1.5.1.tar.gz \
    tidypredict_0.2.0.tar.gz 


RUN DEBIAN_FRONTEND=noninteractive wget \
    https://archive.linux.duke.edu/cran/src/contrib/pROC_1.12.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/gtools_3.8.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/gdata_2.18.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/gplots_3.0.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/MLmetrics_1.1.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/yardstick_0.0.1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/xgboost_0.71.2.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ModelMetrics_1.2.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/caret_6.0-80.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/e1071_1.7-0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/dotCall64_1.0-0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/spam_2.2-0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/fields_9.6.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/ROCR_1.0-7.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/reticulate_1.10.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/tfruns_1.4.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/tensorflow_1.9.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/zeallot_0.1.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/keras_2.2.0.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/coda_0.19-1.tar.gz \
    https://archive.linux.duke.edu/cran/src/contrib/greta_0.2.3.tar.gz 

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL \
    pROC_1.12.1.tar.gz \
    gtools_3.8.1.tar.gz \
    gdata_2.18.0.tar.gz \
    gplots_3.0.1.tar.gz \
    ROCR_1.0-7.tar.gz \
    MLmetrics_1.1.1.tar.gz \
    yardstick_0.0.1.tar.gz \
    xgboost_0.71.2.tar.gz \
    ModelMetrics_1.2.0.tar.gz \
    caret_6.0-80.tar.gz \
    e1071_1.7-0.tar.gz \
    dotCall64_1.0-0.tar.gz \
    spam_2.2-0.tar.gz \
    fields_9.6.tar.gz \
    reticulate_1.10.tar.gz \
    tfruns_1.4.tar.gz \
    tensorflow_1.9.tar.gz \
    zeallot_0.1.0.tar.gz \
    keras_2.2.0.tar.gz \
    coda_0.19-1.tar.gz \
    greta_0.2.3.tar.gz 

RUN rm \
    pROC_1.12.1.tar.gz \
    gtools_3.8.1.tar.gz \
    gdata_2.18.0.tar.gz \
    gplots_3.0.1.tar.gz \
    MLmetrics_1.1.1.tar.gz \
    yardstick_0.0.1.tar.gz \
    xgboost_0.71.2.tar.gz \
    ModelMetrics_1.2.0.tar.gz \
    caret_6.0-80.tar.gz \
    e1071_1.7-0.tar.gz \
    dotCall64_1.0-0.tar.gz \
    spam_2.2-0.tar.gz \
    fields_9.6.tar.gz \
    ROCR_1.0-7.tar.gz \
    reticulate_1.10.tar.gz \
    tfruns_1.4.tar.gz \
    tensorflow_1.9.tar.gz \
    zeallot_0.1.0.tar.gz \
    keras_2.2.0.tar.gz \
    coda_0.19-1.tar.gz \
    greta_0.2.3.tar.gz 


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
