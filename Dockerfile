FROM ruby:3.2-slim-bookworm
WORKDIR /src

RUN apt-get update

# https://jekyllrb.com/docs/installation/other-linux/#debian
RUN apt-get install -y build-essential

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler -v 2.5

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

RUN bundle install
RUN bundle binstubs jekyll --standalone
