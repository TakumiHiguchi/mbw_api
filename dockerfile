FROM ruby:2.5.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN mkdir /mbw_api
WORKDIR /mbw_api

COPY Gemfile /mbw_api/Gemfile
COPY Gemfile.lock /mbw_api/Gemfile.lock

RUN gem install bundler
RUN bundle install

EXPOSE 3020

CMD bundle exec rails server
