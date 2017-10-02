FROM ruby:2.4.1

RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

LABEL maintainer="Emma Black <me@emma.black>"

CMD rails s
