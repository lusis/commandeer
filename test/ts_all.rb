$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "test")))
require 'commandeer'
require 'minitest/autorun'
require 'test_all_override'
require 'test_command'
require 'test_methods'
require 'test_namespaced'
require 'test_output'
require 'test_subcommand'
require 'test_sub_of_real'
