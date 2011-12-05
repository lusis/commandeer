#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"


desc "Run all tests"
task :test do
  tests = Dir.glob('test/test_*.rb')
  tests.shuffle.each do |test|
    sh %{/usr/bin/env ruby #{test}}
  end
end
