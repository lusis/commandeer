#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"


task :test do
  tests = Dir.glob('test/test_*.rb')
  tests.each do |test|
    sh %{/usr/bin/env ruby #{test}}
  end
end
