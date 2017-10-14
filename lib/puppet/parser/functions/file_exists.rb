require "puppet"
module Puppet::Parser::Functions
  newfunction(:file_exists, :type => :rvalue) do |args|
    unless args.length == 1
      raise Puppet::Error, "Function accepts only exactly one arg"
    end
    if File.exists?(args[0])
      return 1
    else
      return 0
    end
  end
end
