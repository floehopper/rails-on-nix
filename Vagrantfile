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

  config.vm.provision 'install webpacker', type: 'shell', privileged: false, inline: <<-SHELL
    cd /vagrant
    nix-shell --run 'rails webpacker:install'
  SHELL
end
