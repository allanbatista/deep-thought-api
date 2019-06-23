FROM ruby:2.6.2

EXPOSE 3000
ENV PORT=3000
ENV RAILS_MAX_THREADS=16
ENV RAILS_ENV=production

# Copy source
RUN mkdir /opt/app
ADD . /opt/app
WORKDIR /opt/app

# install deps
RUN apt-get update && \
    apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev -y && \
    rm -rf /var/lib/apt/lists/*

# Install all packages
RUN gem install rails -v 5.2.3 && \
    bundle install

CMD ["bundle", "exec", "puma"]
