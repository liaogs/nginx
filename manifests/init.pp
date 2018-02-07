class nginx{
  package{"nginx":
    ensure    => present,
  }

  service{"nginx":
    ensure   => running,
    require  => Package["nginx"],
  }
  
  exec {"nginx reload":
    command  => "/usr/sbin/nginx -s reload",
    refreshonly => true,
    subscribe=> File["/etc/nginx/nginx.conf"]
  }

  file{"nginx.conf":
    ensure   => present,
    mode     => 644,
    owner    => root,
    group    => root,
    path     => "/etc/nginx/nginx.conf",
    content  => template("nginx/nginx.conf.erb"),
    require  => Package["nginx"],
  }
}

define nginx::vhost($sitedomain,$rootdir) {
  file{"/etc/nginx/conf.d/${sitedomain}.conf":
    content  => template("nginx/nginx_vhost.conf.erb"),
    require  => Package["nginx"],
    notify   => Exec["nginx reload"],
  }
}
