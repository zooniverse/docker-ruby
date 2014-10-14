FROM debian

ENV LANG en_US.UTF-8
ENV CONFIGURE_OPTS --disable-install-rdoc
ENV JRUBY_OPTS --2.0
ENV DEBIAN_FRONTEND noninteractive

# --no-install-recommends to avoid installing fuse (unsupported in docker < 1.0)
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y git-core curl ca-certificates autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev openjdk-7-jre

RUN git clone https://github.com/sstephenson/ruby-build.git && cd ruby-build && ./install.sh
RUN ruby-build jruby-1.7.16 /usr/local && rm -rf ruby-build
RUN gem install bundler
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /rails_app
