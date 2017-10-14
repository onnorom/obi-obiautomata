class obijiautomata::service::windows (
    String $script,
    String $type,
    String $wkdir,
    String $sleep_interval = lookup('bnsautomata::service::runinterval', String, 'first', '600'),
    Boolean $ensure = true,
) {
  notice("running windows ${type}...")
}
