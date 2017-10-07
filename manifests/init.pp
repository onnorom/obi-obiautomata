class obiautomata ( 
  String $ctrlscript,
  String $servicetype = lookup('obiautomata::service::type', String, 'first', 'service'),
) {

  $updater = $facts['os']['family'] ? {
    'windows' => { 'type' => 'windows', 'script' => "${ctrlscript}" },
    default   => { 'type' => 'default', 'script' => "${ctrlscript}" }
  } 

  notify {"Automating with $name":}
  
  ensure_resource('class', "obiautomata::service::${updater['type']}", { 'script' => "${updater['script']}", 'type' => $servicetype })
}
