class obijiautomata::service::linux (
  String $script,
  String $type,
  String $sleep_interval = lookup('runinterval', String, 'first', '600'),
  Boolean $ensure = true,
) {

    if ($type == 'cron') {
       $myinterval = 0 + $sleep_interval
       $mins = $myinterval / 60

       cron { 'puppet-apply':
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

      $worker_name="automata_worker_${facts['app_environment']}.sh"
      $worker_pid="automata_worker_${facts['app_environment']}.pid"
      $service = { 'start' => "/etc/automata/bin/${worker_name}", 'stop' => '/bin/kill -s SIGUSR1 $MAINPID' }

      file { "/etc/automata/bin/${worker_name}":
        ensure  => present,
        mode    => '0755',
        content => epp('obijiautomata/worker.epp', {
            update_script_path => $script,
            pidfile            => "/var/automata/pid/${worker_pid}",
            sleep_secs         => $sleep_interval,
        })
      }

      # Manage the services
      file { '/etc/systemd/system/obijiautomata.service':
        ensure  => present,
        content => epp('obijiautomata/service.epp', {
            startstr => $service['start'],
            stopstr  => $service['stop'],
        })
      }

      # Reload the changed file
      exec { '/bin/systemctl daemon-reload':
        refreshonly => true,
        notify      => Service['obijiautomata'],
        require     => File['/etc/systemd/system/obijiautomata.service'],
      }

      # Enable service in the node and startup if not explicitly turned off
      service { 'obijiautomata':
        ensure    => $ensure,
        enable    => true,
        subscribe => File['/etc/systemd/system/obijiautomata.service'],
        require   => File['/etc/systemd/system/obijiautomata.service'],
      }
   } else {
      fail("Unsupported service type ${type}...")
   }
}
