# development.pp
stage { 'req-install': before => Stage['rvm-install'] }

class requirements {
  group { "puppet": ensure => "present", }
  exec { "apt-update":
    command => "/usr/bin/apt-get -y update"
  }

  package {
    ["mysql-client", "mysql-server", "libmysqlclient-dev"]:
      ensure => installed, require => Exec['apt-update']
  }
}


# Use the full version number for specifying rvm rubies.
# From https://github.com/blt04/puppet-rvm:
# While the shorthand version may work (e.g. '1.9.2'),
# the provider will be unable to detect if the correct version is installed.
class installrvm {
  include rvm
  rvm::system_user { vagrant: ; }

  if $rvm_installed == "true" {
    rvm_system_ruby {
      'ruby-1.9.3-p194':
        ensure    => 'present',
        default_use => true;
    }
  }
}

class doinstall {
  class { requirements:, stage => "req-install" }
  include installrvm
}

include doinstall
