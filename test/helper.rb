require 'test/unit'

require 'rubygems'
require 'rake'

begin
  require 'ruby-debug'
rescue LoadError
end

begin
  require 'shoulda'
  require 'rr'
  require 'redgreen'
rescue LoadError => e
  puts "*" * 80
  puts "Some dependencies needed to run tests were missing. Run the following command to find them:"
  puts
  puts "\trake check_dependencies:development"
  puts "*" * 80
  exit 1
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'y2s'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)
end
