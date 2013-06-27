group { 'puppet': 
  ensure => 'present' 
}
class { 'apache': }

# virtual host with alternate options
# you could roll this a lot of different ways
apache::vhost { 'github2glass.vm':
  port => '80',
  docroot => '/vagrant/',
  options => [
    'FollowSymLinks',
  ],
  override => 'All',
}

# just get some PHP; leave FPM for another day
class php {
  package { "php5":
    ensure => present,
  }
 
  package { "php5-cli":
    ensure => present,
  }
  
  package { 'php5-sqlite': 
	ensure => 'present' 
  }
  
  package { 'php5-curl': 
	ensure => 'present' 
  }
}

class sqlite {
  package { 'sqlite3':
    ensure => 'present',
  }
  
  exec { "create-database":
    path    => ["/bin", "/usr/bin"],
    command => "touch /vagrant/db/database.sqlite"
  }
  
  exec { "database-permissions":
    path    => ["/bin", "/usr/bin"],
    command => "chmod 777 /vagrant/db/database.sqlite",
	require => [Exec["create-database"] ]
  }
}




include apache
include apache::mod::php
apache::mod { 
	'rewrite': 
}
include php
include sqlite

