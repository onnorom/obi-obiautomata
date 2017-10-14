class obijiautomata::service::default (
  String $script,
  String $type,
  String $wkdir,
  String $sleep_interval = lookup('obijiautomata::service::runinterval', String, 'first', '600'),
  Boolean $ensure = true,
) {

  $automata_title = split($title, '::')
  $automaton = $automata_title[0]

  class {"${automaton}::service::linux::gatekeeper": 'ctrldir' => $wkdir} 
  if ($type == 'cron') {
    $myinterval = 0 + $sleep_interval
    $mins = $myinterval / 60

    cron { "puppet-apply-${automaton}":
      ensure  => present,
      command => $script,
      user    => 'root',
      minute  => "*/${mins}",
    }
  } elsif ($type == 'service') { 
      ensure_resource ('file', '/var/automata', { ensure => 'directory', mode   => '0755' })
      ensure_resource ('file', '/var/automata/pid', { ensure => 'directory', mode   => '0755' })
      ensure_resource ('file', '/var/automata/logs', { ensure => 'directory', mode   => '0755' })
      ensure_resource ('file', '/etc/automata', { ensure => 'directory', mode   => '0755' })
      ensure_resource ('file', '/etc/automata/bin', { ensure => 'directory', mode   => '0755' })

      $worker_name="${automaton}-${facts['app_environment']}.sh"
      $worker_pid="${automaton}-${facts['app_environment']}.pid"
      $service = { 'start' => "/etc/automata/bin/${worker_name}", 'stop' => '/bin/kill -s SIGUSR1 $MAINPID' }

      file { "/etc/automata/bin/${worker_name}":
        ensure  => present,
        mode    => '0755',
        content => epp("${automaton}/worker.epp", {
            update_script_path => $script,
            pidfile            => "/var/automata/pid/${worker_pid}",
            sleep_secs         => $sleep_interval,
        }),
      }

      # Manage the services
      file { "/etc/systemd/system/${automaton}-${facts['app_environment']}.service":
        ensure  => present,
        content => epp("${automaton}/service.epp", {
            startstr => $service['start'],
            stopstr  => $service['stop'],
            pidfile  => "/var/automata/pid/${worker_pid}",
        }),
        require => File["/etc/automata/bin/${worker_name}"],
      }

      # Reload the changed file
      exec { '/bin/systemctl daemon-reload':
        refreshonly => true,
        notify      => Service[$automaton],
        require     => File["/etc/systemd/system/${automaton}-${facts['app_environment']}.service"],
      }

      # Enable service in the node and start it unless explicitly turned off
      service { "${automaton}-${facts['app_environment']}":
        ensure    => $ensure,
        enable    => true,
        subscribe => File["/etc/systemd/system/${automaton}-${facts['app_environment']}.service"],
        require   => File["/etc/systemd/system/${automaton}-${facts['app_environment']}.service"],
      }
  } else {
     fail("Unsupported service type ${type}...")
  }
}
