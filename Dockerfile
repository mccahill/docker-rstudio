FROM  ubuntu:22.04

ENV TZ America/New_York

RUN echo 'rebuild'

# Core Tools
RUN apt-get update  \
    && apt-get dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get  install -y --no-install-recommends \
        vim-tiny \
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
        sqlite3 \
        gdal-bin \
        libgdal-dev \
        build-essential \
        gdebi-core \
        locales \
        tzdata \
        gnupg2 \
        apt-utils \
        ssh \
        software-properties-common \
        libmagick++-dev


# Supervisord 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
       supervisor && \
       mkdir -p /var/log/supervisor
CMD ["/usr/bin/supervisord", "-n"]

# set the locale so RStudio doesn't complain about UTF-8
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

# set the timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive 

# we need TeX for the rmarkdown package in RStudio, and pandoc is also useful 
RUN add-apt-repository universe && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        pandoc

RUN  wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
     tar -zxf install-tl-unx.tar.gz  && \
     cd install-tl-* && \
     perl ./install-tl --no-interaction 

RUN echo 'PATH=/usr/local/texlive/2022/bin/x86_64-linux:$PATH' >> /etc/bash.bashrc		

# Libraries
RUN apt-get update \
    && apt-get  install -y --no-install-recommends \
        libopenblas-base \
        libcurl4-openssl-dev \
        libxml2-dev \
        libssl-dev \
        libfreetype6-dev \
        libudunits2-dev \
        libtiff-dev \
        libcairo2-dev \
        libxt-dev \
        libavfilter-dev \
        libopenmpi-dev \
        libblas-dev \
        liblapack-dev \
        libarpack2-dev \
        libglpk40
		

RUN apt install --no-install-recommends -y \
    software-properties-common \
	dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: 298A3A825C0D65DFD57CBB651716619E084DAB9
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt install --no-install-recommends -y \
    r-base \
    r-base-dev \
    r-recommended \
    littler \
&& ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
&& install.r docopt \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Install R-Studio server latest 
RUN wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.07.1-554-amd64.deb \
    && DEBIAN_FRONTEND=noninteractive gdebi --n rstudio-server-2022.07.1-554-amd64.deb \
    && rm rstudio-server-2022.07.1-554-amd64.deb

# quatro - now bundled with rstudio, only needed if we want a newer version
#RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.0.38/quarto-1.0.38-linux-amd64.deb \
#    && DEBIAN_FRONTEND=noninteractive gdebi --n quarto-1.0.38-linux-amd64.deb \
#    && rm quarto-1.0.38-linux-amd64.deb

ADD ./Rprofileconf /Rprofile_conf 
RUN ls -la  /Rprofile_conf/*
RUN mv /Rprofile_conf/Rprofile.site /usr/lib/R/etc/Rprofile.site
#RUN    rmdir /Rprofile_conf/
   
# R packages base stuff
RUN install2.r --error -s --deps TRUE \
    rmarkdown \
    tidyverse \
    tidymodels \
    shiny \
    shinyjs \
    shinythemes \
    shinydashboard \
    devtools 


# R packages A-G
RUN install2.r --error -s --deps TRUE \
    anyflights \
    arm \
    ash \
    babynames \
    BHH2 \
    credentials \
    datasauRus \
    DiagrammeR \
    flexdashboard \
    forecast \
    forecTheta \
    gert \
    gganimate \
    ggdendro \
    ggforce \
    ggformula \
    ggmap \
    ggraph \
    gh \
    gifski \
    gitcreds \
    googlesheets4 

# R packages H-Z
RUN install2.r --error -s --deps TRUE \
    here \
    highlight \
    Hmisc \
    hms \
    learnr \
    lintr \
    magic \
    mapproj \
    maps \
    maptools \
    mosaic \
    mosaicCore \
    mosaicData \
    NHANES \
    openintro \
    palmerpenguins \
    profvis \
    r2d3 \
    rcmdcheck \
    renv \
    rjson \
    RJSONIO \
    robotstxt \
    robustbase \
    skimr \
    spiderbar \
    splines2 \
    tufte

# R packages - spatial
RUN install2.r --error -s --deps TRUE \
    raster

RUN Rscript -e "install.packages('spDataLarge', repos = 'https://geocompr.r-universe.dev')"

RUN install2.r --error -s --deps TRUE \
    sf \
    sp \
    rgeos \
    rgdal \
    leaflet \
    spData \
    spdep \
    spatialreg

# R packages - other
RUN install2.r --error -s --deps TRUE \
    bayesplot \
    cowplot \
    downlit \
    DT \
    GGally \
    miniUI \
    nycflights13 \
    ragg \
    RcppParallel \
    repurrrsive \
    rsconnect \
    rstantools \
    StanHeaders \
    stopwords \
    fs \
    janitor \
    ggridges \
    ggthemes

RUN installGithub.r \
    rstudio/gradethis \
    rstudio-education/dsbox



RUN install2.r --error -s --deps TRUE \
    igraph \
    BAS  \
    airports \
    bench \
    betareg \
    BH \
    BHH2 \
    bitops \
    blogdown \
    bookdown \
    car \
    carData \
    caret \
    caTools \
    cherryblossom \
    chron \
    config \
    conquer \
    corrplot \
    credentials \
    CVST \
    cyclocomp

# broken here
# Config files
ADD ./biocInstalls /biocInstalls
RUN R CMD BATCH /biocInstalls/extras.R
RUN cat rm /extras.Rout ; rm /extras.Rout 

RUN install2.r --error -s --deps TRUE \
    datasauRus \
    ddalpha \
    deldir \
    dendextend \
    DEoptimR \
    devtools \
    DiagrammeR \
    DiceDesign \
    dichromat \
    diffobj \
    dimRed \
    distributional \
    doMC \
    doParallel \
    dotCall64 \
    downloader \
    drat \
    DRR \
    dslabs
		
RUN install2.r --error -s --deps TRUE \
    effects \
    enc \
    evd \
    expm \
    fda \
    fds \
    fields \
    flexdashboard \
    flexmix \
    FNN \
    fontBitstreamVera \
    fontLiberation \
    fontquiver \
    forecast \
    forecTheta \
    forge \
    formatR \
    fracdiff \
    future.apply \
    gcookbook \
    gdata

RUN install2.r --error -s --deps TRUE \
    geometry \
    geosphere \
    gert \
    gganimate \
    ggdendro \
    ggforce \
    ggformula \
    ggmap \
    ggraph \
    gh \
    gitcreds \
    gmodels \
    googlesheets4 \
    gower \
    GPfit \
    gplots \
    graphlayouts \
    greta \
    gridSVG \
    hdrcde \
    here \
    highlight \
    Hmisc \
    hms \
    HSAUR3 \
    htmlTable



RUN install2.r --error -s --deps TRUE \
    import \
    ini \
    jpeg \
    keras \
    kernlab \
    ks \
    labelled \
    latticeExtra \
    leafem \
    leaflet \
    leaflet.providers \
    leafsync \
    LearnBayes \
    learnr \
    linprog \
    lintr \
    lmtest \
    locfit \
    lwgeom \
    magic \
    mapproj \
    maps \
    maptools \
    MatrixModels \
    matrixStats \
    mclust \
    mice \
    microbenchmark

RUN install2.r --error -s --deps TRUE \
    MLmetrics \
    mnormt \
    ModelMetrics \
    mosaic \
    mosaicCore \
    mosaicData \
    msm \
    multcomp \
    multicool \
    NHANES \
    openintro \
    openxlsx \
    palmerpenguins \
    pbkrtest \
    pcaPP \
    PKI \
    plotROC \
    pls \
    polspline \
    polyclip \
    profmem \
    profvis \
    pryr \
    psych

RUN install2.r --error -s --deps TRUE \
    quantmod \
    quantreg \
    R.cache \
    R.methodsS3 \
    R.oo \
    R.rsp \
    R.utils \
    r2d3 \
    rainbow \
    raster \
    rcmdcheck \
    RcppProgress \
    RcppRoll \
    RCurl \
    remotes \
    renv \
    repr \
    reticulate \
    rgexf \
    RgoogleMaps \
    rio \
    rjson \
    RJSONIO \
    rms


RUN install2.r --error -s --deps TRUE \
    robotstxt \
    robustbase \
    ROCR \
    Rook \
    rticles \
    RUnit \
    rversions \
    RWiener \
    sandwich \
    scatterplot3d \
    seasonal \
    selectr \
    servr \
    sessioninfo \
    sf \
    sfsmisc \
    skimr \
    sp \
    spam \
    sparklyr
	

RUN install2.r --error -s --deps TRUE \
    SparseM \
    spData \
    spdep \
    spiderbar \
    splines2 \
    stars \
    statmod \
    stringdist \
    styler \
    tensorflow \
    tfruns \
    TH.data \
    tmap \
    tmaptools \
    tmvnsim \
    tseries \
    TTR \
    udunits2
	

RUN install2.r --error -s --deps TRUE \
    ape \
    bridgesampling \
    Brobdingnag \
    colourpicker \
    corpcor \
    covr \
    cowplot \
    cubature \
    dotwhisker \
    downlit \
    DT \
    dygraphs \
    emmeans 

# needed for something below
RUN Rscript -e "install.packages('cmdstanr', repos = c('https://mc-stan.org/r-packages/', getOption('repos')))" 

RUN install2.r --error -s --deps TRUE \
    gamm4 \
    GGally \
    glmbb \
    inline \
    ISOcodes \
    loo \
    MCMCglmm \
    miniUI \
    nleqslv \
    optimx \
    plogr \
    projpred \
    rngtools \
    rstantools \
    StanHeaders \
    bindrcpp \
    threejs \
    pairwiseCI
#added pairwiseCI per Meredith
    


# R packages 
RUN install2.r --error -s --deps TRUE \
    tidybayes \
    tidygraph \
    tidypredict \
    tidyr \
    tidyselect \
    tidytext \
    tidytuesdayR

RUN install2.r --error -s --deps TRUE \
    unvotes

# the maintainer removed this package from CRAN, but it is still available in the archives
RUN DEBIAN_FRONTEND=noninteractive wget  \
    https://cran.r-project.org/src/contrib/Archive/freetypeharfbuzz/freetypeharfbuzz_0.2.6.tar.gz
RUN DEBIAN_FRONTEND=noninteractive R CMD INSTALL  \
     freetypeharfbuzz_0.2.6.tar.gz
RUN rm freetypeharfbuzz_0.2.6.tar.gz

# the default packages for everyone running R
RUN echo "" >> /etc/R/Rprofile.site && \
    echo "# add the downloader package to the default libraries" >> /etc/R/Rprofile.site && \
    echo ".First <- function(){" >> /etc/R/Rprofile.site && \
    echo "library(downloader)" >> /etc/R/Rprofile.site && \
    echo "library(knitr)" >> /etc/R/Rprofile.site && \
    echo "library(rmarkdown)" >> /etc/R/Rprofile.site && \
    echo "library(ggplot2)" >> /etc/R/Rprofile.site && \
    echo "library(googlesheets4)" >> /etc/R/Rprofile.site && \
    echo "library(openintro)" >> /etc/R/Rprofile.site && \
    echo "library(GGally)" >> /etc/R/Rprofile.site && \
    echo "library(babynames)" >> /etc/R/Rprofile.site && \
    echo "}" >> /etc/R/Rprofile.site  && \
    echo "" >> /etc/R/Rprofile.site


RUN adduser --disabled-password --gecos "" --ingroup users guest 

# Config files
ADD ./conf /r-studio-configs 
RUN cd /r-studio-configs && \
    cp rserver.conf /etc/rstudio/ && \
    cp rsession.conf /etc/rstudio/ && \
    cp database.conf /etc/rstudio/ && \
    chown guest /etc/rstudio/* && \
    chown guest /var/log/supervisor
#RUN rm -rf /r-studio-configs

# Needed by gert which is needed by usethis
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libgit2-dev

RUN Rscript -e "tinytex::install_tinytex()"
RUN install2.r --error -s --deps TRUE fivethirtyeight 
RUN install2.r --error -s -r "https://fivethirtyeightdata.github.io/drat/" fivethirtyeightdata
RUN echo "PATH=/usr/local/texlive/2022/bin/x86_64-linux:$PATH" >> /etc/R/Renviron.site 

# set the glorious TZ env variable site-wide for R contexts
RUN echo 'TZ="America/New_York"' >> /etc/R/Renviron.site 

#########
#
# if you need additional tools/libraries, add them here.
# also, note that we use supervisord to launch both the password
# initialize script and the RStudio server. If you want to run other processes
# add these to the supervisord.conf file
#
#########

RUN apt-get autoremove -y \
    && apt-get clean

# expose the RStudio IDE port
EXPOSE 8787 
RUN cp /r-studio-configs/supervisord.conf /etc/supervisor/supervisord.conf

USER guest
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
