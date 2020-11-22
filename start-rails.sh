#!/usr/bin/env bash

echo "Start rails: $RAILS_APP_NAME"
cd /vagrant/$RAILS_APP_NAME

# Generate blog in rails app using scaffold
nix-shell --run 'rails generate scaffold Post title:string content:text'

# Create & migrate databases in rails app
nix-shell --run 'rails db:create'
nix-shell --run 'rails db:migrate'

# Run tests in rails app
nix-shell --run 'rails test'

# Start rails server in background
nix-shell --run 'rails server --binding 0.0.0.0 --port $RAILS_SERVER_PORT --daemon'
