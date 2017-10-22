define obijiautomata::service::linux::preinstall (
  String $servicetype,
) {

  case $servicetype {
    file { '/var/automata/pid/automata.pid':
      ensure => absent,
    }->
    service: {
      service { $title:
        ensure    => stopped,
        enable    => false,
        hasstatus => false,
      }->file { ["/etc/systemd/system/${title}.service","/etc/automata/bin/${title}.sh"]:
           ensure => absent,
      }
    }
    cron: {
      cron { $title:
        ensure => absent,
      }
    }
  }
}
