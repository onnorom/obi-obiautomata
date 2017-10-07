class obiautomata::service::windows (
    String $script,
    String $type,
    String $sleep_interval = lookup('runinterval', String, 'first', '600'),
    Boolean $ensure = true,
) {
  notice("running windows ${type}...")
}
