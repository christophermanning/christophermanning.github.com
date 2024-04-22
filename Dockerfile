FROM ruby:2.7.3-alpine3.13

WORKDIR /src

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler -v 1.16.1

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock 

RUN apk --no-cache add \
  bash \
  build-base \
  readline \
  libffi \
  libressl \
  zlib

RUN bundle install
RUN bundle binstubs jekyll --standalone
