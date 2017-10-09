Facter.add(:app_environment) do
  setcode do
    if File.exist? "/etc/.host.app.env"
      Facter::Util::Resolution.exec("cat /etc/.host.app.env 2> /dev/null").chomp
    else
      'production'
    end
  end
end
