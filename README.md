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

* Takes quite a while (~12 mins on my 3.1 GHz Dual-Core Intel Core i7 MacBook Pro).

* Installs the Nix package manager.

* Uses an ephemeral Nix shell to generate the `Gemfile.lock`, `gemset.nix` & `shell.nix` files to make the Rails gem, its dependent gems, and its dependent OS packages available.

* From within the Nix shell specified by the `gemset.nix` & `shell.nix` files generated in the previous step, generates a new Rails app, `my-rails-app`.

* Within the Rails app sub-directory, uses another ephemeral Nix shell to generate the `Gemfile.lock`, `gemset.nix` & `shell.nix` files to make the gems bundled in the Rails app, their dependent gems, and their dependent OS packages available.

* Within the Rails app sub-directory, from within the Nix shell specified by the `gemset.nix` & `shell.nix` files generated in the previous step, installs webpacker, creates & migrates the databases, runs the tests, and runs the Rails server in the background.

### View website

View http://localhost:3000/ in your browser.

## Notes

### Accessing the Rails app environment on the VM

On your local machine, run:

    vagrant ssh

On the VM, run:

    cd /vagrant/my-rails-app
    nix-shell

### Provisioning the VM multiple times

Most of the provisioning operations are fairly idempotent, but it's simplest to run the `./clean.sh` script and re-provision the VM with `vagrant provision` from a relatively clean slate.

## Further work

* Investigate using Nix home-manager to provide a more generic environment on the VM to create the Rails app, i.e. run `rails new`.

* Investigate using Nix to make node.js packages available instead of yarn.

* Use different database types, e.g. PostgreSQL & MySQL.

* Multiple Rails apps with different dependencies.
