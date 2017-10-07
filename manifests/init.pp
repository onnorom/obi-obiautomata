class obijiautomata ( 
  String $ctrlscript,
  String $servicetype = lookup('obijiautomata::service::type', String, 'first', 'service'),
) {

  $updater = $facts['os']['family'] ? {
    'windows' => { 'type' => 'windows', 'script' => "${ctrlscript}" },
    default   => { 'type' => 'default', 'script' => "${ctrlscript}" }
  } 

  notify {"Automating with $name":}
  
  ensure_resource('class', "obijiautomata::service::${updater['type']}", { 'script' => "${updater['script']}", 'type' => $servicetype })
}
