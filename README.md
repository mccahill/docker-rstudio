RStudio in a Docker Container
=============================

## What is this?

This project is an example of running RStudio from within a Docker container.
In addition to the basic RStudio server, the container also has the knitr and
Rmarkdown libraries so it is easy to create nicely formatted output. There is 
also just enough of TeX to allow knitr to generate PDF output.

## How to build 

Build the container with the command:

```
sudo docker build -t="r-studio" .
```

Since the build file points directly at quite a few R extensions in the CRAN 
repository, and since those extension are being updated, there is the distinct possibility
that the build file will complain about not being able fetch a specific library.
If this happens, look through the file list here: http://cran.r-project.org/src/contrib/
to find the new version of the library and update the Dockerfile.

## How to run

Run using the default password from the Dockerfile build script:
```
sudo docker run -d -p 0.0.0.0:8787:8787 -i -t r-studio
```

PROTIP: You will probably want to  something more secure than an account
named guest with the password guest, so you will probably want pass in the
guest user password when you instance the container.

```
docker run -d -p 0.0.0.0:8787:8787 -e USERPASS=badpassword  -i -t r-studio
```

You probably want the user's home directory to persist, so if the container restarts
the users' work is not blown away. To do this, map a home directory like this:
```
docker run -d -e USERPASS=badpassword  \
        -v /external/directory/for/user:/home/guest \
        -p 0.0.0.0:8787:8787 -i -t r-studio
```

## How to access

To access the app, point your web browser at
    http://your.hostname.here:8787/

You will be prompted to login. Use the username 'guest' and the password 'badpassword'


## Run a large scale RStudio container farm

Suppose you want to run RStudio for a couple hundred users, and want to keep 
each user sequestered as much as possible. To do this you would want to run an
Rstudio container for each user, and map the user's home directory to an external
volume. 

You would also need to map each user to a different port, and keep track of
the mapping of user to port and external home directory volume -- and you need
to have unique passwords for each user.

With all this information in hand, you could construct URLs specific to each user and
after they have authenticated at some other web site, redirect them to the appropriate
container and automatically log them in. Ideally, you would also run the entire RStudio 
session over https so that everything is encrypted.

To accomplish all of this, we use two additional containerized services:
- nginx (https://github.com/nginxinc/docker-nginx) 
- docker-gen (https://github.com/jwilder/docker-gen).

Nginx provides https support by accepting https connections and proxying them to the appropriate
rstudio container port on the local server. Nginx needs a configuration file to to know what
to do, and the prospect of maintaining a config file for over a hundred rstudio containers
was not appealing, so we take advantage of docker-gen to dynamically update the nginx config as containers are started/stopped.

Docker-gen tracks activity (container starts/stops) from the docker daemon, and based
on the VIRTUAL_HOST environmental variable for the containers can select an appropriate
template to use for updating the nginx config file. This is cool because it means that
we are not faced with manually updating the nginx config - instead docker-gen updates it
for us. 

With a little bit of shell scripting it is possible to read a mapping file that lists users and passwords for RStudio users, and based on this file launch RDtudio containers -- something you
will want to be able to do when your server starts. 

For details on the configurations of these services used at Duke and how to script startup of
a cluster of rstudio instances front-ended by nginx and docker-gen see
https://github.com/mccahill/docker-gen/tree/duke


### Test Containers
https://labs-az-01.oit.duke.edu/auth-sign-in
https://labs-az-02.oit.duke.edu/auth-sign-in
https://labs-az-03.oit.duke.edu/auth-sign-in