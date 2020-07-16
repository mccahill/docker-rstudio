#!/usr/bin/Rscript

# get command line arguments
pkgs <- commandArgs(TRUE)

# set command line arguments
args <- grep("=", pkgs)

for(i in args)
{
    tmp <- gsub("\"|'", '', unlist(strsplit(pkgs[args[i]], "=")))
    
    eval(parse(text = paste0(tmp[1], ' <- tmp[2]')))
}

# drop command line arguments from package list
pkgs <- pkgs[-args]

# set defaults if not specified in command line arguments
if(!exists('repos'))
    repos <- "http://cran.us.r-project.org"

if(!exists('lib'))
    lib <- "/usr/lib/R/library"

# install packages and dependencies, but only if they aren't already installed
for(p in pkgs)
{
    # get rid of repository owner if on GitHub
    if(repos == 'github')
    {
        p_tmp <- strsplit(p, '/')[[1]][2]
    }else{
        p_tmp <- p
    }
    
    if(!require(p_tmp, character.only = TRUE, quietly = TRUE))
    {
        if(repos == 'github')
        {
            if(!require('devtools', quietly = TRUE))
                install.packages('devtools', repos = "http://cran.us.r-project.org", quiet = TRUE, dependencies = TRUE, lib = lib)
            
            devtools::install_github(p, quiet = TRUE, dependencies = TRUE, lib = lib, upgrade = "never",
                                     repos = "http://cran.us.r-project.org")
        }else{
            install.packages(p, repos=repos, quiet = TRUE, dependencies = TRUE, lib = lib)
        }
    }
}
