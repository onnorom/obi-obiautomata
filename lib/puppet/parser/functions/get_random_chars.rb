require "puppet"
module Puppet::Parser::Functions
  newfunction(:get_random_chars, :type => :rvalue, :doc => <<-EOS
    Returns random characters.
  EOS
  ) do |args|
      raise(Puppet::ParseError, "get_random_chars(): incorrect number of arguments (#{arg.size} instead of 1)") if args.size != 1
      specials = ((33..33).to_a + (35..38).to_a + (40..47).to_a + (58..64).to_a + (91..93).to_a + (95..96).to_a + (123..125).to_a).pack('U*').chars.to_a
      numbers = (0..9).to_a
      alphal = ('a'..'z').to_a
      alphau = ('A'..'Z').to_a
      length = args[0].to_i
      CHARS = (alphal + specials + numbers + alphau)
      xChars= CHARS.sort_by { rand }.join[0...length]
      return xChars
  end
end
