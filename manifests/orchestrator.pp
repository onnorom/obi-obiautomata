class obijiautomata::orchestrator ( 
  String $servicetype = lookup('obijiautomata::service::type', String, 'first', 'cron'),
) {

  if ($facts['automata_ctrldir'] != undef) {
    $ctrldir = $facts['automata_ctrldir']
  } else {
    fail("Missing fact (automata_ctrldir) required to run")
  }

  $updater = $facts['os']['family'] ? {
    'Windows' => { 'type' => 'windows', 'script' => "${ctrldir}\\update.bat" },
    /(RedHat|Debian|CentOS)/ => { 'type' => 'linux', script=>"${ctrldir}/update.sh" },
    default   => { 'script' => "${ctrldir}/update.sh", type=>$::osfamily }, 
  } 

  if defined("obijiautomata::service::${updater['type']}") {
    ensure_resource('class', "obijiautomata::service::${updater['type']}", { 'script' => "${updater['script']}", 'type' => $servicetype, 'wkdir' => $ctrldir })
  } else {
    fail("Unsupported operating system (${updater['type']})")
  }
}
