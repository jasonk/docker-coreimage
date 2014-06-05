jasonk/coreimage - An opinionated Docker base image
==============================================

This image is intended for use with [my docker-builder
tools](http://github.com/jasonk/docker-builder) (though there is no reason you
couldn't use it on it's own).  It provides a minimal framework on which to
build a [Docker](http://www.docker.io/) container.

The image is based on an ubuntu base, with a minimal runtime that still
provides the necessary services for running and managing containers that
provide multiple services.

What is included in this image?
=================

 * [Ubuntu 13.10 - Saucy Salamander](http://www.ubuntu.com/)
    * base image 
 * [runit](http://smarden.org/runit/)
    * as the init process and service supervisor
 * [xinetd](http://www.xinetd.org)
    * super-server daemon
 * [cron](http://ftp.isc.org/isc/cron/)
    * for periodic task running
 * [docker-utils](http://github.com/jasonk/docker-utils)
   * Helpful utility scripts for docker environments

Getting Started
===============

If you just want to take a look at what is in the image, the easiest way is to
run this command:

    docker run --rm -t -i jasonk/coreimage bash

This will download the image if you don't already have it, and start it up in
docker.  Keep in mind that running it this way it will run bash instead of
runit, so none of the services will actually start.

Configuration Tool
==================

This image contains a very helpful tool, named 'docker-coreimage'.  You can use
it to easily configure the most important parts of the container.  I recommend
reviewing the source code if you want to see the details of how each of these
things is done.

See the [Wiki](http://github.com/jasonk/docker-coreimage/wiki) for more details
about how to perform common tasks.

Test Suite
==========

The startup process for this image includes a script that checks whether
/test-suite is a mountpoint.  If it is a mountpoint, then the startup script
launches a background process that sleeps for 15 seconds, then changes
directory to /test-suite, and runs any executables it finds there.

You can use this to run an automated test suite against the image, by mounting
a local directory on /test-suite, like so:

    docker run -v /path/to/test-suite:/test-suite -t -i --rm jasonk/coreimage

The distribution includes a test harness that uses
[roundup.sh](https://github.com/bmizerany/roundup) to run any test scripts
found in the tests/ directory.  You can either use that harness as-is and add
your own tests to the tests directory, or just replace the whole thing with
whatever test runner you would prefer.

Configuring Services
====================

There are two kinds of services supported by this image:  Persistent services
managed by runit, and on-demand services managed by xinetd.  Running through
runit is good for the applications that your container is intended to run,
while xinetd is very helpful for launching management processes and things
that don't need to be running all the time.

The default configuration uses runit to manage xinetd and cron, and uses xinetd
to manage some helpful network utilities.

Building your own images based on jasonk/coreimage
==================================================

First, create a directory and a Dockerfile for your new image, and make sure
the Dockerfile starts with this coreimage as it's base.
    % mkdir my-image
    % cd my-image
    % cat <<END > Dockerfile
    FROM jasonk/docker-coreimage:latest
    
    # Set correct environment variables.
    ENV HOME /root

    # Run whatever additional commands you want to run here..
    RUN ....
    END

Adding additional services
==========================

runit services
--------------

To add a service that should be monitored by runit, create a runit
configuration directory in /etc/sv:

    % mkdir my-service
    % cat <<END > my-service/run
    #!/bin/sh
    exec /app/my-service-runner
    END

Then in your Dockerfile:

    ADD my-service /etc/sv/

xinetd services
---------------

To add a service that should be monitored by xinetd, create a configuration
file in /etc/xinetd.d:

    % cat <<END > myservice.conf
    service myservice {
        socket_type = stream
        protocol = tcp
        wait = no
        user = root
        server = /usr/local/sbin/myservice
        instances = 2
    }
    END

Then in your Dockerfile:

    ADD myservice.conf /etc/xinetd.d/myservice

Author and Related Information
==============================

This image was created and is maintained by
Jason Kohles <email@jasonkohles.com> http://www.jasonkohles.com/

  * [Github](http://github.com/jasonk/docker-coreimage)
  * [Issues](http://github.com/jasonk/docker-coreimage/issues)
  * [Wiki](http://github.com/jasonk/docker-coreimage/wiki)
  * [Docker Registry](http://index.docker.io/u/jasonk/coreimage)
