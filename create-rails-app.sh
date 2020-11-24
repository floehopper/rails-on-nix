#!/usr/bin/env bash
set -ex

echo "Create rails app: $RAILS_APP_NAME"

# Copy user-level bundler config
mkdir -p ./.bundle
cp /vagrant/.bundle/config ./.bundle/

# Create Gemfile specifically for running `rails new` command
rm -f Gemfile
cat <<EOS >Gemfile
source 'https://rubygems.org'
ruby '2.6.6'
gem 'rails', '= $RAILS_VERSION'
EOS

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
RAILS_MAJOR_VERSION=`echo $RAILS_VERSION | cut -d'.' -f1`
if [ $RAILS_MAJOR_VERSION -gt 5 ]; then
  nix-shell --run 'rails webpacker:install'
else
  nix-shell --run 'rails yarn:install'
fi
