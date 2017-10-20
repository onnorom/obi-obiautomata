if Facter.value(:kernel) == 'Linux'
  array = Dir.glob('/etc/automata/bin/*.sh')
  hash = {}
  array.each do |item|
    hash[hash.size] = item 
  end
  Facter.add('automata_workers') do
    setcode do
    #  hash
      array
    end
  end
end

