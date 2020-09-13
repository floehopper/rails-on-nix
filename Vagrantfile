Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000

  config.vm.provision 'install nix', type: 'shell', privileged: false, inline: <<-SHELL
    nix --version
    if [ $? -eq 0 ]; then
      echo 'nix is already installed (skipping installation)'
    else
      # https://nixos.org/manual/nix/stable/#sect-multi-user-installation
      sh <(curl -L https://nixos.org/nix/install) --daemon
    fi
  SHELL

  config.vm.provision 'create new rails app', type: 'shell', privileged: false, inline: <<-SHELL
    cd /vagrant

    # Make rails gem specified by Gemfile available from nix-shell
    nix-shell -p ruby_2_6 bundler bundix --run 'bundle lock && bundix --init --ruby=ruby_2_6'

    # Generate new rails app
    nix-shell --run 'rails new my-rails-app --skip-bundle --skip-webpack-install'

    cd my-rails-app

    # Make gems specified in rails app Gemfile available in nix-shell
    nix-shell -p ruby_2_6 bundler bundix --run 'bundle lock && bundix --init --ruby=ruby_2_6'

    # Make node.js, yarn & ruby_2_6 packages available in nix-shell
    sed -i 's/buildInputs = \\[ env \\]/buildInputs = \\[ env nodejs yarn ruby_2_6 \\]/g' shell.nix

    # Setup webpacker in rails app
    nix-shell --run 'rails webpacker:install'

    # Create & migrate databases in rails app
    nix-shell --run 'rails db:create'
    nix-shell --run 'rails db:migrate'

    # Run tests in rails app
    nix-shell --run 'rails test'

    # Start rails server in background
    nix-shell --run 'rails server --binding 0.0.0.0 --daemon'
  SHELL
end
