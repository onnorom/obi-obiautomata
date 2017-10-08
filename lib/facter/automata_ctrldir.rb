Facter.add(:automata_ctrldir) do
  setcode do
    if File.exist? "/etc/.host.control.dir"
      Facter::Util::Resolution.exec("cat /etc/.host.control.dir 2> /dev/null").chomp
    end
  end
end
