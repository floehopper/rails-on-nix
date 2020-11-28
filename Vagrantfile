Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.network 'forwarded_port', guest: 3001, host: 3001

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  config.vm.provision 'install-nix', type: 'shell', privileged: false, path: './install-nix.sh'

  config.vm.provision 'ruby2.5-rails6.0.3.4-postgres10-create', type: 'shell', privileged: false, path: './create-rails-app.sh', env: {
    'RAILS_APP_NAME' => 'ruby2.5-rails6.0.3.4-postgres10',
    'RUBY_VERSION' => '2.5',
    'RAILS_VERSION' => '6.0.3.4',
    'RAILS_DATABASE_TYPE' => 'postgresql',
    'DATABASE_PACKAGE' => 'postgresql_10'
  }

  config.vm.provision 'ruby2.5-rails6.0.3.4-postgres10-config', type: 'shell', privileged: false, path: './configure-postgresql.sh', env: {
    'RAILS_APP_NAME' => 'ruby2.5-rails6.0.3.4-postgres10'
  }

  config.vm.provision 'ruby2.5-rails6.0.3.4-postgres10-start', type: 'shell', privileged: false, path: './start-rails.sh', env: {
    'RAILS_APP_NAME' => 'ruby2.5-rails6.0.3.4-postgres10',
    'RAILS_SERVER_PORT' => '3000'
  }

  config.vm.provision 'ruby2.6-rails5.2.4.4-mysql5.7-create', type: 'shell', privileged: false, path: './create-rails-app.sh', env: {
    'RAILS_APP_NAME' => 'ruby2.6-rails5.2.4.4-mysql5.7',
    'RUBY_VERSION' => '2.6',
    'RAILS_VERSION' => '5.2.4.4',
    'RAILS_DATABASE_TYPE' => 'mysql',
    'DATABASE_PACKAGE' => 'mysql57'
  }

  config.vm.provision 'ruby2.6-rails5.2.4.4-mysql5.7-config', type: 'shell', privileged: false, path: './configure-mysql.sh', env: {
    'RAILS_APP_NAME' => 'ruby2.6-rails5.2.4.4-mysql5.7'
  }

  config.vm.provision 'ruby2.6-rails5.2.4.4-mysql5.7-start', type: 'shell', privileged: false, path: './start-rails.sh', env: {
    'RAILS_APP_NAME' => 'ruby2.6-rails5.2.4.4-mysql5.7',
    'RAILS_SERVER_PORT' => '3001'
  }
end
