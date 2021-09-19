ARG VERSION=2.7.4

FROM ruby:${VERSION}

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /rails
COPY Gemfile /rails/Gemfile
COPY Gemfile.lock /rails/Gemfile.lock
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
