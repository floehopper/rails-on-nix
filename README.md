# Rails on Nix

This is an exploration of setting up a vanilla Rails app using the Nix package manager.

I'm using an Ubuntu VM via Vagrant to ensure the environment is as isolated as possible from my own local environment (MacOS).

## Step-by-step instructions

### Install Vagrant & VirtualBox

In the local (MacOS) environment:

    brew cask install vagrant
    brew cask install virtualbox

### Clone the repo

In the local (MacOS) environment:

    git clone git@github.com:floehopper/rails-on-nix.git

### Start & provision the VM

In the local (MacOS) environment:

    cd rails-on-nix
    vagrant up

* Takes quite a while!
* Installs the Nix package manager.
* Runs a Nix shell which makes Ruby, the bundled gems, and their OS package dependencies available.
* Runs `rails webpacker:install` within this shell to complete the setup of the Rails app.

### Run the Rails server

On your local machine, run:

    vagrant ssh

On the VM, run:

    cd /vagrant
    nix-shell
    rails server --binding 0.0.0.0

### View website

View http://localhost:3000/ in your browser.

## Notes

### Generating Rails app

I cheated and did this in my local development environment using:

    rails new rails-on-nix

### Generating Gemfile.lock, shell.nix & gemset.nix

* Assuming you already have a `Gemfile` run the following command: `nix-shell -p ruby_2_6 bundler bundix --run 'bundle lock && bundix --init --ruby=ruby_2_6'`

* Add `nodejs` & `yarn` to the `buildInputs` array in the `shell.nix` generated in the previous step. These are needed in order to be able to run `rails webpacker:install` (and possibly other things?).

## Further work

* Provide an environment on the VM to create the Rails app, i.e. run `rails new`. It might make sense to use Nix home-manager to do this.

* Investigate using Nix to make node.js packages available instead of `yarn`.

* Use different database types, e.g. PostgreSQL & MySQL.
