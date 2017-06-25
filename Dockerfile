FROM ruby:2.4.1

ENV BUILD_PACKAGES="bash curl tzdata ca-certificates wget less ssh" \
    DEV_PACKAGES="ruby-dev libc-dev libffi-dev libmysqlclient-dev libxml2-dev libxslt-dev" \
    RUBY_PACKAGES="mysql-client git openssl" \
    GEM_HOME=/app/bundle \
    BUNDLE_PATH=/app/bundle \
    BUNDLE_APP_CONFIG=/app/bundle \
    APP=/app/webapp \
    PATH=/app/webapp/bin:/app/bundle/bin:$PATH

RUN set -ex \
    && apt-get update \
    && apt-get install -qq -y --force-yes build-essential --fix-missing --no-install-recommends \
    $BUILD_PACKAGES \
    $DEV_PACKAGES \
    $RUBY_PACKAGES \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash -
    && apt-get -y install python build-essential nodejs \
    && npm install -g yarn \
    && mkdir -p "$APP" "$GEM_HOME/bin" \
    && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
    } >> ~/.gemrc \
    && apt-get clean \
    && rm -rf '/var/lib/apt/lists/*' '/tmp/*' '/var/tmp/*' \
    && mkdir ~/.ssh \
    && chmod 700 ~/.ssh

RUN gem install bundler
RUN gem install rails -v '~> 5.1.1'
# RUN gem install nokogiri -v '>= 1.5.9'

WORKDIR $APP

EXPOSE 3000
