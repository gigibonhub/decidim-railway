ARG base_image=ghcr.io/decidim/decidim-generator:0.31.4

FROM $base_image
LABEL maintainer="hola@decidim.org"

WORKDIR /code

RUN decidim . --queue sidekiq
RUN sed -i 's/config.force_ssl = true/config.force_ssl = false/' config/environments/production.rb
RUN bundle check || bundle install
RUN bundle exec rake assets:precompile

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

EXPOSE 3000

ENTRYPOINT []

CMD ["sh", "-c", "bundle exec rails s -b 0.0.0.0 -p ${PORT:-3000}"]