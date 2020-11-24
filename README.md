# Rails on Nix

This is an exploration of setting up vanilla Rails apps using the Nix package manager.

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

* Provisioning the VM takes quite a while!

* Installs the Nix package manager.

* For each Rails app (`rails-postgres-app` & `rails-mysql-app`):
    * Uses an ephemeral Nix shell to generate the `Gemfile.lock`, `gemset.nix` & `shell.nix` files to make the Rails gem, its dependent gems, and its dependent OS packages available.
    * From within the Nix shell specified by the `gemset.nix` & `shell.nix` files generated in the previous step, generates a new Rails app.
    * Within the Rails app sub-directory, uses another ephemeral Nix shell to generate the `Gemfile.lock`, `gemset.nix` & `shell.nix` files to make the gems bundled in the Rails app, their dependent gems, and their dependent OS packages available.
    * Within the Rails app sub-directory, from within the Nix shell specified by the `gemset.nix` & `shell.nix` files generated in the previous step:
        * installs OS packages which are runtime dependencies for the Rails app: node.js, yarn & ruby_2_6
        * also installs appropriate database OS package
        * installs webpacker
        * sets up and starts database server
        * generates simple "blog" using scaffold
        * creates & migrates the databases
        * runs the tests
        * runs the Rails server in the background

### View websites

#### rails-postgres-app

* View http://localhost:3000/ in your browser.
* View http://localhost:3000/posts to see generated "blog" pages.

#### rails-mysql-app

* View http://localhost:3001/ in your browser.
* View http://localhost:3001/posts to see generated "blog" pages.

## Notes

### Accessing the Rails app environment on the VM

On your local machine, run:

    vagrant ssh

On the VM, run:

    cd /vagrant/$RAILS_APP_NAME
    nix-shell

### Provisioning the VM multiple times

Most of the provisioning operations are _fairly_ idempotent, but I haven't tested this thoroughly.

## Further work

* Investigate using Nix home-manager to provide a more generic environment on the VM to create the Rails app, i.e. run `rails new`.

* Investigate using Nix to make node.js packages available instead of yarn.

* Consider moving Rails app directories under $HOME and moving database files into a sub-directory within the relevant Rails app.

* Multiple Rails app requiring different versions of PostgreSQL and MySQL.
