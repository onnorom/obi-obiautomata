define obijiautomata::service::linux::uninstall (
  $target,
  String $ensure = 'stopped',
  Boolean $enable = false,
) {

  case $target {
    service: {
      $servicename = inline_template('<%=File.basename(@title)%>')
      service { $servicename:
        ensure    => $ensure,
        enable    => $enable,
      }->exec { $title:
           command   => "rm -f ${title}",
           onlyif    => "test -f ${title}",
           path      => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin'],
      }
    }
    processfile: {
      file { $title:
        path   => $title,
        ensure => 'absent',
      }
    }
    cronjob: {
      cron { $title:
        ensure => 'absent',
      }
    }
  }
 
}
