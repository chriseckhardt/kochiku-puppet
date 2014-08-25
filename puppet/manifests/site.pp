node default {
  include ::role::kochiku::server
}

node /worker/ {
  include ::role::kochiku::worker
}

class role::kochiku::server {
  include ::profile::kochiku::database
  include ::profile::kochiku::server
}

class role::kochiku::worker {
  include ::profile::kochiku::worker
}

class profile::kochiku {
  # Install Ruby >= 2.1
  # rvm module requires Puppet >= 3.
  # We use a shell provisioning script to ensure latest Puppet is installed
  # before we invoke this module.
  include rvm
  rvm_system_ruby {'ruby-2.1.2':
    ensure      => 'present',
    default_use => true,
  }
  rvm::system_user {'vagrant':}
  rvm_gemset {'ruby-2.1.2@kochiku':
    ensure  => present,
    require => Rvm_system_ruby['ruby-2.1.2'],
  }
  rvm_gem {'ruby-2.1.2@kochiku/bundler':
    ensure  => '1.6.1',
    require => Rvm_gemset['ruby-2.1.2@kochiku'],
  }
}

class profile::kochiku::server inherits ::profile::kochiku {
  # Clone Kochiku from GitHub
  vcsrepo {'/vagrant/kochiku':
    ensure   => present,
    provider => git,
    # Change this to a value using a forked repo you can commit back to
    source   => 'https://github.com/square/kochiku.git',
  } ->
  exec {'build_kochiku_server':
    command => 'bundle install && rake db::setup && rails server',
    path    => '/usr/local/rvm/gems/ruby-2.1.2/bin/bundle',
    cwd     => '/vagrant/kochiku',
    user    => 'vagrant',
    require => [Rvm_gem['ruby-2.1.2@kochiku/bundler'],Package[$::mysql::params::server_package_name]],
  }
}

class profile::kochiku::worker inherits ::profile::kochiku {
  # Clone Kochiku-Worker from GitHub
  vcsrepo {'/vagrant/kochiku-worker':
    ensure   => present,
    provider => git,
    # Change this to a value using a forked repo you can commit back to
    source   => 'https://github.com/square/kochiku-worker.git',
    } ->
    exec {'build_kochiku_worker':
      command => 'bundle install && QUEUE=ci,developer rake resque:work',
      path    => '/usr/local/rvm/gems/ruby-2.1.2/bin/bundle',
      cwd     => '/vagrant/kochiku-worker',
      user    => 'vagrant',
      require => [Rvm_gem['ruby-2.1.2@kochiku/bundler'],Package[$::mysql::params::server_package_name]],
    }
}

class profile::kochiku::database {
  class {'::mysql::server':
    root_password    => '',
    override_options => $override_options,
  }
}
