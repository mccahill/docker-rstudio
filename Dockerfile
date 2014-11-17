FROM   ubuntu:12.04
MAINTAINER Mark McCahill "mark.mccahill@duke.edu"

# no Upstart or DBus
# https://github.com/dotcloud/docker/issues/1724#issuecomment-26294856
RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl
RUN apt-get update \
    && apt-get upgrade -y

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat python-software-properties

# need wget and the curl dev libraries to install and run R-Studio and associated packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget sudo libcurl4-openssl-dev 

# we need TeX for the rmarkdown package in RStudio - this backport seems to work
RUN apt-add-repository ppa:texlive-backports/ppa
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y texlive texlive-base texlive-latex-extra texlive-pstricks

# get R from the CRAN archive at http://cran.cnr.Berkeley.edu 
RUN DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 
RUN echo "deb http://cran.cnr.Berkeley.edu/bin/linux/ubuntu precise/" >> /etc/apt/sources.list 
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y r-base r-base-dev

# R-Studio
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y gdebi-core
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libapparmor1
RUN DEBIAN_FRONTEND=noninteractive wget http://download2.rstudio.org/rstudio-server-0.98.1028-amd64.deb
RUN DEBIAN_FRONTEND=noninteractive gdebi -n rstudio-server-0.98.1028-amd64.deb
RUN rm rstudio-server-0.98.1028-amd64.deb

# update the R packages we will need for knitr
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/knitr_1.8.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/yaml_2.1.13.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/htmltools_0.2.6.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/caTools_1.17.1.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/bitops_1.0-6.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/digest_0.6.4.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/stringr_0.6.2.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/markdown_0.7.4.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/highr_0.4.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/formatR_1.0.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/evaluate_0.5.5.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/mime_0.2.tar.gz

RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL bitops_1.0-6.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL caTools_1.17.1.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL digest_0.6.4.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL htmltools_0.2.6.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL yaml_2.1.13.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL stringr_0.6.2.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL highr_0.4.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL formatR_1.0.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL evaluate_0.5.5.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL mime_0.2.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL markdown_0.7.4.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL knitr_1.8.tar.gz
RUN rm evaluate_0.5.5.tar.gz
RUN rm formatR_1.0.tar.gz
RUN rm highr_0.4.tar.gz
RUN rm markdown_0.7.4.tar.gz
RUN rm stringr_0.6.2.tar.gz
RUN rm knitr_1.8.tar.gz
RUN rm yaml_2.1.13.tar.gz
RUN rm htmltools_0.2.6.tar.gz
RUN rm caTools_1.17.1.tar.gz
RUN rm bitops_1.0-6.tar.gz
RUN rm digest_0.6.4.tar.gz
RUN rm mime_0.2.tar.gz

# R packages we need for devtools - and we need devtools to be able to update the rmarkdown package
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/rstudioapi_0.1.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/devtools_1.6.1.tar.gz
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/httr_0.5.tar.gz 
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/RCurl_1.95-4.3.tar.gz 
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/memoise_0.2.1.tar.gz 
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/whisker_0.3-2.tar.gz 
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/jsonlite_0.9.13.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL jsonlite_0.9.13.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL memoise_0.2.1.tar.gz 
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL whisker_0.3-2.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL RCurl_1.95-4.3.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL httr_0.5.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL rstudioapi_0.1.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL devtools_1.6.1.tar.gz
RUN rm jsonlite_0.9.13.tar.gz
RUN rm whisker_0.3-2.tar.gz
RUN rm memoise_0.2.1.tar.gz
RUN rm RCurl_1.95-4.3.tar.gz
RUN rm httr_0.5.tar.gz
RUN rm devtools_1.6.1.tar.gz
RUN rm rstudioapi_0.1.tar.gz

# downloader
RUN DEBIAN_FRONTEND=noninteractive wget http://cran.r-project.org/src/contrib/downloader_0.3.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL downloader_0.3.tar.gz
RUN rm downloader_0.3.tar.gz

# install rmarkdown
ADD ./conf /r-studio
RUN R CMD BATCH /r-studio/install-rmarkdown.R
RUN rm /install-rmarkdown.Rout 

#Supervisord
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor && \
	mkdir -p /var/log/supervisor
CMD ["/usr/bin/supervisord", "-n"]

#Config files
RUN cd /r-studio && \
    cp supervisord-RStudio.conf /etc/supervisor/conf.d/supervisord-RStudio.conf
RUN rm /r-studio/*

# add downloader to the default packages for everyone running R
RUN echo "" >> /etc/R/Rprofile.site && \
    echo "# add the downloader package to the default libraries" >> /etc/R/Rprofile.site && \
    echo ".First <- function(){ library(downloader) }" >> /etc/R/Rprofile.site && \
    echo "" >> /etc/R/Rprofile.site

# add a non-root user so we can log into R studio as that user
RUN (adduser --disabled-password --gecos "" guest && echo "guest:guest"|chpasswd)

# set the locale so RStudio doesn't complain about UTF-8
RUN locale-gen en_US en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

EXPOSE 8787 

CMD ["/usr/bin/supervisord"]

