define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly,
   }
}

class bamboo {
  include java

  $bamboo-archive = "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.2.tar.gz"
  $bamboo-app = "/vagrant/atlassian-bamboo-5.2"
  $bamboo-home = "/vagrant/bamboo-home"
  $bamboo-start = "$bamboo-app/bin/start-bamboo.sh"

  exec {
    "download_bamboo":
    command => "curl -L $bamboo-archive | tar zx",
    cwd => "/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    logoutput => true,
    timeout => 0,
    creates => "$bamboo-app",
  }

 exec {
    "create_bamboo_home":
    command => "mkdir -p $bamboo-home",
    cwd => "/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Exec["download_bamboo"],
    logoutput => true,
    creates => "$bamboo-home",    
  }

  append_if_no_such_line { 
    "configure-bamboo-home":
    file => "$bamboo-app/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties",
    line => "\nbamboo.home=$bamboo-home",
  }

  exec {
    "start_bamboo_in_background":
    command => "$bamboo-start &",
    cwd => "/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => [ Package["java"],
                 Exec["create_bamboo_home"] ],
    logoutput => true,
  }

  append_if_no_such_line { motd:
    file => "/etc/motd",
    line => "Run bamboo with: $bamboo-start",
    require => Exec["start_bamboo_in_background"],
  }

}

include bamboo


include apt

# this repo is needed vor collectd version 5.3
apt::ppa { "ppa:vbulax/collectd5": }

exec { "apt-update":
	command => '/usr/bin/apt-get update',
	user => root,
	require => Apt::Ppa["ppa:vbulax/collectd5"],
}


class { '::collectd':
  require => Exec["apt-update"]
}

include collectd

class { 'collectd::plugin::write_graphite':
  graphitehost => '10.0.2.2',
}
