#!/bin/bash

# Install system dependencies
apt-get update
apt-get install -y build-essential sqlite3 libsqlite3-dev

# Install Ruby gems and prepare database
bundle install
rails db:create
