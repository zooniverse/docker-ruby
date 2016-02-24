FROM zooniverse/java

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
    wget -qO- https://github.com/sstephenson/ruby-build/archive/v20141028.tar.gz | \
    tar xz -C ruby-build/ --strip-components 1 && \
    cd ruby-build && \
    ./install.sh && \
    ruby-build jruby-1.7.16 /usr/local && rm -rf ruby-build

RUN gem install bundler jbundler:0.5.5

WORKDIR /rails_app
