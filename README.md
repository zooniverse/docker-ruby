docker-ruby
===========

Minimal Docker Containers for different rubies

## Usage

Run `rake config` to setup a Docker username to create the image
under, select additional default dependencies (comma or space
seperated), and set a default ruby to build.

`rake build` compiles the Dockerfile.erb into a Dockerfile for the
default ruby version specified and runs docker build against it.

`rake build ruby=other_ruby_version` builds your box with a different
version of ruby specified.

`rake deploy` uploads the containers to Docker Hub.

## License

Copyright 2014 by the Zooniverse

Distributed under the Apache Public License v2. See LICENSE

