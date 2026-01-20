FROM ruby:3.3.1-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    git \
    pkg-config

# Set working directory
WORKDIR /rails

# Set environment variables for development
ENV BUNDLE_PATH="/usr/local/bundle"
ENV RAILS_ENV="development"

# Install Rails
RUN gem install rails -v 7.1.3.2

# Entrypoint setup
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
