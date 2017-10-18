define obijiautomata::service::linux::gatekeeper (
  String $ctrldir,
  Boolean $remove = true,
  String $servicetype = nil,
) {

  $automata_title = split($title, '::')
  $automaton_prefix = $automata_title[0]
  $autoctrl = generate("/bin/bash","-c","/bin/ls ${ctrldir}/.cache/locks 2>/dev/null |tr -t '\n' ' '")
  $serviceinfo = { 'cron' => "puppet-apply-${automaton_prefix}", 'service' => "${automaton_prefix}-${facts['app_environment']}" }

  if ! empty($autoctrl) and $autoctrl =~ /\w+/ {
    $autoservices = generate("/bin/bash","-c","/bin/ls /etc/systemd/system/${automaton_prefix}* 2>/dev/null | tr -t '\n' ':'")
    $autoservice_files = split($autoservices, ":")

    if ! empty($autoservice_files) {
      $autoservice_files.each |$autosrv| {
        notice (basename($autosrv), "is already set up on this server")
      }

      unless $remove { fail('Please consider removing existing service(s)') }

      # Stop and remove service
      notice (basename($autosrv), "will be removed. Please rerun setup to reinstall if needed")
      obijiautomata::service::linux::uninstall { $autoservice_files: target => 'service' }
    }

    if ($facts['automata_workers'] != undef) {
      $h=$facts['automata_workers']
      if ! empty($h) {
        case $h {
          Array: {  
            $x = $h
            $h.each |$autoscript| { notice (basename($autoscript), "process file will be removed") } 
          }
          Hash : {
            $x = $h.reduce([]) |Array $value, $keyval| { $value + $keyval[1] }
            $x.each |$autoscript| { notice (basename($autoscript), "process file will be removed") }
          }
        }

        unless $remove { fail('Please clean up old service(s) process(es)') }

        # Remove service process file(s)
        obijiautomata::service::linux::uninstall { $x: target => 'processfile' }
      }
    }

    $cronservice = generate("/bin/bash","-c","grep puppet-apply-${automaton_prefix} /var/spool/cron/crontabs/root | tr -t '\n' ':'")
    $cronservice_files = split($cronservice, ":")
    if ! empty($cronservice_files) {
      # Remove cron job(s)
      obijiautomata::service::linux::uninstall { "puppet-apply-${automaton_prefix}": target => 'cronjob' }
    }
  } elsif (! empty($servicetype)) and ($servicetype != nil) {
      case $servicetype {
        service: {
          $cronservice = generate("/bin/bash","-c","grep puppet-apply-${automaton_prefix} /var/spool/cron/crontabs/root | tr -t '\n' ':'")
          $cronservice_files = split($cronservice, ":")
          $target = 'cron'
          if ! empty($cronservice_files) {
            # Remove cron job(s) if running
            obijiautomata::service::linux::preinstall { $serviceinfo[$servicetype]: servicetype => $target }
            obijiautomata::service::linux::uninstall { "puppet-apply-${automaton_prefix}": target => 'cronjob' }
          }
        }
        cron: {
          $autoservices = generate("/bin/bash","-c","/bin/ls /etc/systemd/system/${automaton_prefix}* 2>/dev/null | tr -t '\n' ':'")
          $autoservice_files = split($autoservices, ":")
          $target = 'service'

          if ! empty($autoservice_files) {
            $autoservice_files.each |$autosrv| {
              notice (basename($autosrv), "is already set up on this server")
            }

            unless $remove { fail('Please consider removing existing service(s)') }

            # Stop and remove service if running
            obijiautomata::service::linux::preinstall { $serviceinfo[$servicetype]: servicetype => $target }
            obijiautomata::service::linux::uninstall { $autoservice_files: target => 'service' }
          }
        }
        default: { $target = 'none' }
      }
  }
}
