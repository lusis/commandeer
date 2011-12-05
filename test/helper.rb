$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "test")))
gem 'minitest' if RUBY_VERSION =~ /1.9/

require 'minitest/pride'
require 'minitest/autorun'
require 'commandeer'
Commandeer.reset!
