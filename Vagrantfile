Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.network 'forwarded_port', guest: 3001, host: 3001

  config.vm.provision 'install nix', type: 'shell', privileged: false, path: './install-nix.sh'

  config.vm.provision 'create rails-postgres-app', type: 'shell', privileged: false, path: './create-rails-app.sh', env: {
    'RAILS_APP_NAME' => 'rails-postgres-app',
    'RAILS_VERSION' => '6.0.3.4',
    'RAILS_DATABASE_TYPE' => 'postgresql',
    'DATABASE_PACKAGE' => 'postgresql'
  }

  config.vm.provision 'configure postgresql', type: 'shell', privileged: false, path: './configure-postgresql.sh', env: {
    'RAILS_APP_NAME' => 'rails-postgres-app'
  }

  config.vm.provision 'start rails-postgres-app', type: 'shell', privileged: false, path: './start-rails.sh', env: {
    'RAILS_APP_NAME' => 'rails-postgres-app',
    'RAILS_SERVER_PORT' => '3000'
  }

  config.vm.provision 'create rails-mysql-app', type: 'shell', privileged: false, path: './create-rails-app.sh', env: {
    'RAILS_APP_NAME' => 'rails-mysql-app',
    'RAILS_VERSION' => '5.2.4.4',
    'RAILS_DATABASE_TYPE' => 'mysql',
    'DATABASE_PACKAGE' => 'mysql'
  }

  config.vm.provision 'configure mysql', type: 'shell', privileged: false, path: './configure-mysql.sh', env: {
    'RAILS_APP_NAME' => 'rails-mysql-app'
  }

  config.vm.provision 'start rails-mysql-app', type: 'shell', privileged: false, path: './start-rails.sh', env: {
    'RAILS_APP_NAME' => 'rails-mysql-app',
    'RAILS_SERVER_PORT' => '3001'
  }
end
