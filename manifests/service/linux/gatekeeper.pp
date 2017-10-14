class obijiautomata::service::linux::gatekeeper (
  String $ctrldir,
  Boolean $remove = true,
) {

  $automata_title = split($title, '::')
  $automaton_prefix = $automata_title[0]
  $autoctrl = generate("/bin/bash","-c","/bin/ls ${ctrldir}/.cache/locks 2>/dev/null |tr -t '\n' ' '")

  if ! empty($autoctrl) {
    $autoservices = generate("/bin/bash","-c","/bin/ls /etc/systemd/system/${automaton_prefix}* 2>/dev/null | tr -t '\n' ':'")
    $autoservice_files = split($autoservices, ":")

    if ! empty($autoservice_files) {
      $autoservice_files.each |$autosrv| {
        notice (basename($autosrv), "is already set up on this server")
      }

      unless $remove { fail('Please consider removing existing service(s)') }

      # Stop and remove service
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

    # Remove cron job(s)
    obijiautomata::service::linux::uninstall { "puppet-apply-${automaton_prefix}": target => 'cronjob' }
  }
}
