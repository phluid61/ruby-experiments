
require "#{File.dirname(__FILE__)}/../ext/gettime/gettime.#{RbConfig::CONFIG['DLEXT']}"

=begin
begin
  require 'gettime/gettime'
rescue LoadError
  begin
    require "gettime/gettime.#{RbConfig::CONFIG['DLEXT']}"
  rescue LoadError
    require "gettime.#{RbConfig::CONFIG['DLEXT']}"
  end
end
=end

