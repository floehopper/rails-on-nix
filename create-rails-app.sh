#!/usr/bin/env bash
set -ex

echo "Create rails app: $RAILS_APP_NAME"
cp /vagrant/Gemfile .

# Make rails gem specified by Gemfile available from nix-shell
rm -f Gemfile.lock gemset.nix shell.nix
nix-shell -p ruby_2_6 bundler bundix --run 'bundle lock && bundix --init --ruby=ruby_2_6'

# Generate new rails app
rm -rf $RAILS_APP_NAME
nix-shell --run 'rails new $RAILS_APP_NAME --skip-bundle --skip-webpack-install --database=$RAILS_DATABASE_TYPE'

cd $RAILS_APP_NAME

# Make gems specified in rails app Gemfile available in nix-shell
nix-shell -p ruby_2_6 bundler bundix --run 'bundle lock && bundix --init --ruby=ruby_2_6'

# Make node.js, yarn, database & ruby_2_6 packages available in nix-shell
sed -i 's@buildInputs = \[ env \]@buildInputs = \[ env nodejs yarn '"$DATABASE_PACKAGE"' ruby_2_6 \]@g' shell.nix

# Setup webpacker in rails app
nix-shell --run 'rails webpacker:install'
