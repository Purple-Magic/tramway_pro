# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.1
ARG DISTRO_NAME=bullseye

# Here we add the the name of the stage ("base")
FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME AS base

ARG PG_MAJOR
ARG NODE_MAJOR
ARG YARN_VERSION

# Common dependencies
# ...
# The following lines are exactly the same as before
# ...
# ...
WORKDIR /app

EXPOSE 9292
CMD ["/usr/bin/bash"]

# Then, we define the "development" stage from the base one
FROM base AS development

ENV RAILS_ENV=development

# The major difference from the base image is that we may have development-only system
# dependencies (like Vim or graphviz).
# We extract them into the Aptfile.dev file.
COPY Aptfile.dev /tmp/Aptfile.dev
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/Aptfile.dev | xargs)

# The production-builder image is responsible for installing dependencies and compiling assets
FROM base as production-builder

# Git for installing gems from Github
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq \
  && apt-get dist-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    git-core \
    curl

COPY AptRMagickGemDependencies /tmp/AptRMagickGemDependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/AptRMagickGemDependencies | xargs)

COPY AptReactRailsGemDependencies /tmp/AptReactRailsGemDependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/AptReactRailsGemDependencies | xargs)

COPY AptPgGemDependencies /tmp/AptPgGemDependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/AptPgGemDependencies | xargs)

COPY AptYarnDependencies /tmp/AptYarnDependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/AptYarnDependencies | xargs)

# # Install yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apt -y update && apt install -y yarn

# First, we create and configure a dedicated user to run our application
RUN groupadd --gid 1005 tramway \
  && useradd --uid 1005 --gid tramway --shell /bin/bash --create-home tramway
USER tramway
RUN mkdir /home/tramway/app
WORKDIR /home/tramway/app

# Then, we re-configure Bundler
ENV RAILS_ENV=production \
  LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_APP_CONFIG=/home/tramway/bundle \
  BUNDLE_PATH=/home/tramway/bundle \
  GEM_HOME=/home/tramway/bundle

# Install Ruby gems
COPY --chown=tramway:tramway Gemfile Gemfile.lock ./
RUN mkdir $BUNDLE_PATH
RUN bundle config --local deployment 'true'
RUN bundle config --local path "${BUNDLE_PATH}"
RUN bundle config --local without 'development test'
RUN bundle config --local clean 'true'
RUN bundle config --local no-cache 'true'
RUN bundle install --jobs=${BUNDLE_JOBS}
RUN rm -rf $BUNDLE_PATH/ruby/3.1.0/cache/*
RUN rm -rf /home/tramway/.bundle/cache/*

# # Install JS packages
# COPY --chown=tramway:tramway package.json yarn.lock ./
# RUN yarn install --check-files

# Copy code
COPY --chown=tramway:tramway . .

# Precompile assets
# NOTE: The command may require adding some environment variables (e.g., SECRET_KEY_BASE) if you're not using
# credentials.
# RUN bundle exec rails assets:precompile

# Finally, our production image definition
# NOTE: It's not extending the base image, it's a new one
FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME AS production

# Production-only dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq \
  && apt-get dist-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl \
    gnupg2 \
    less \
    tzdata \
    time \
    locales \
    nodejs \
  && update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

COPY AptMimemagickGemDependencies /tmp/AptMimemagickGemDependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/AptMimemagickGemDependencies | xargs)

COPY AptPgGemDependencies /tmp/AptPgGemDependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/AptPgGemDependencies | xargs)

COPY AptRMagickGemDependencies /tmp/AptRMagickGemDependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/AptRMagickGemDependencies | xargs)

COPY AptNodeModulesDependencies /tmp/AptNodeModulesDependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/AptNodeModulesDependencies | xargs)

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt -y update && apt install -y yarn

# Create and configure a dedicated user (use the same name as for the production-builder image)
RUN groupadd --gid 1005 tramway \
  && useradd --uid 1005 --gid tramway --shell /bin/bash --create-home tramway
RUN mkdir /home/tramway/app
WORKDIR /home/tramway/app
USER tramway

# Ruby/Rails env configuration
ENV RAILS_ENV=production \
  BUNDLE_APP_CONFIG=/home/tramway/bundle \
  BUNDLE_PATH=/home/tramway/bundle \
  GEM_HOME=/home/tramway/bundle \
  PATH="/home/tramway/app/bin:${PATH}" \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8

EXPOSE 9292

# Copy code
COPY --chown=tramway:tramway . .

# Copy artifacts
# 1) Installed gems
COPY --from=production-builder $BUNDLE_PATH $BUNDLE_PATH

# Install JS packages
RUN yarn install --check-files

RUN bundle exec rails assets:precompile

# RUN sudo rm -rf node_modules

# 2) Compiled assets
# COPY --from=production-builder /home/tramway/app/public/packs /home/tramway/app/public/packs
# COPY --from=production-builder /home/tramway/app/public/assets /home/tramway/app/public/assets
# 3) We can even copy the Bootsnap cache to speed up our Rails server load!
# COPY --chown=tramway:tramway --from=production-builder /home/tramway/app/tmp/cache/bootsnap* /home/tramway/app/tmp/cache/

RUN chmod +x /home/tramway/app/run.sh
