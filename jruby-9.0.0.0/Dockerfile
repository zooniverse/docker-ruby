FROM ubuntu:14.04

ENV LANG en_US.UTF-8
ENV CONFIGURE_OPTS --disable-install-rdoc 
ENV JRUBY_OPTS --2.0
ENV DEBIAN_FRONTEND noninteractive

# --no-install-recommends to avoid installing fuse (unsupported in docker < 1.0)
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget build-essential ca-certificates openjdk-7-jre-headless && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir ruby-build && \
    wget -qO- https://github.com/sstephenson/ruby-build/archive/v20150803.tar.gz | \ 
    tar xz -C ruby-build/ --strip-components 1 && \
    cd ruby-build && \
    ./bin/ruby-build jruby-9.0.0.0 /usr/local && rm -rf ruby-build
    
RUN gem install bundler jbundler

WORKDIR /rails_app
