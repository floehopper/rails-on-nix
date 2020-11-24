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
gem 'rails', '= $RAILS_VERSION'
EOS

RUBY_MAJOR_VERSION=`echo $RUBY_VERSION | cut -d'.' -f1`
RUBY_MINOR_VERSION=`echo $RUBY_VERSION | cut -d'.' -f2`
RUBY_NIX_PACKAGE="ruby_${RUBY_MAJOR_VERSION}_${RUBY_MINOR_VERSION}"

cat <<EOS >bundler.nix
with (import <nixpkgs> {});
let
  myBundler = bundler.override { ruby = $RUBY_NIX_PACKAGE; };
in
mkShell {
  name = "bundler-shell";
  buildInputs = [ myBundler ];
}
EOS

rm -f Gemfile.lock
nix-shell --run "bundle lock" bundler.nix

cat <<EOS >shell.nix
with (import <nixpkgs> {});
let
  env = bundlerEnv {
    name = "$RAILS_APP_NAME";
    ruby = $RUBY_NIX_PACKAGE;
    gemdir = ./.;
  };
in mkShell { buildInputs = [ env env.wrappedRuby ]; }
EOS

rm -f gemset.nix
nix-shell -p bundix --run "bundix"

# Generate new rails app
rm -rf $RAILS_APP_NAME
nix-shell --run "rails new $RAILS_APP_NAME --skip-bundle --skip-webpack-install --database=$RAILS_DATABASE_TYPE"

cd $RAILS_APP_NAME

cat <<EOS >bundler.nix
with (import <nixpkgs> {});
let
  myBundler = bundler.override { ruby = $RUBY_NIX_PACKAGE; };
in
mkShell {
  name = "bundler-shell";
  buildInputs = [ myBundler ];
}
EOS

rm -f Gemfile.lock
nix-shell --run "bundle lock" bundler.nix

cat <<EOS >shell.nix
with (import <nixpkgs> {});
let
  env = bundlerEnv {
    name = "$RAILS_APP_NAME";
    ruby = $RUBY_NIX_PACKAGE;
    gemdir = ./.;
  };
in mkShell {
  buildInputs = [ env env.wrappedRuby nodejs yarn $DATABASE_PACKAGE ];
}
EOS

rm -f gemset.nix
nix-shell -p bundix --run "bundix"

# Setup webpacker in rails app
RAILS_MAJOR_VERSION=`echo $RAILS_VERSION | cut -d'.' -f1`
if [ $RAILS_MAJOR_VERSION -gt 5 ]; then
  nix-shell --run 'rails webpacker:install'
else
  nix-shell --run 'rails yarn:install'
fi
