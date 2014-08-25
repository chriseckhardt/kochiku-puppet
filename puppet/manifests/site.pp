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
  # Installing RVM breaks system Puppet so we install it into the default gem-
  # set for subsequent runs of Puppet.
  rvm_gem {'ruby-2.1.2@kochiku/puppet':
    ensure  => present,
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
  }
  class {'redis':}
}

class profile::kochiku::worker inherits ::profile::kochiku {
  # Clone Kochiku-Worker from GitHub
  vcsrepo {'/vagrant/kochiku-worker':
    ensure   => present,
    provider => git,
    # Change this to a value using a forked repo you can commit back to
    source   => 'https://github.com/square/kochiku-worker.git',
    }
}

class profile::kochiku::database {
  class {'::mysql::server':
    #root_password    => '',
    #override_options => ,
  }
}
