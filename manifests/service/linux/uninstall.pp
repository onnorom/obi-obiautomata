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
      }->file { $title:
           ensure => 'absent',
      }
    }
    processfile: {
      file { $title:
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
