FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs jq
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ADD Gemfile /usr/src/app/Gemfile
ADD Gemfile.lock /usr/src/app/Gemfile.lock
RUN bundle install
ADD . /usr/src/app