Facter.add(:app_environment) do
  setcode do
  if File.exist? "/etc/.host.app.env" and File.open('/etc/.host.app.env').readlines.any?{ |line| line =~ /\w+/ } 
    Facter::Util::Resolution.exec("cat /etc/.host.app.env |sed 's/\"//g' 2>/dev/null").chomp
  else
    'production'
  end
  end
end
