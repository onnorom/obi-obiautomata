Facter.add(:checkoutdir) do
  confine :kernel => 'Linux'
  setcode do
     Facter::Util::Resolution.exec('pwd')
  end
end
