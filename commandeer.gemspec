# -*- encoding: utf-8 -*-
require File.expand_path('../lib/commandeer', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John E. Vincent"]
  gem.email         = ["lusis.org+github.com@gmail.com"]
  gem.description   = %q{Class-based CLI utility}
  gem.summary       = "Commandeer allows you to make any class a git style command or subcommand"
  gem.homepage      = "https://github.com/lusis/commandeer"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ark"
  gem.require_paths = ["lib"]
  gem.version       = Commandeer::VERSION
end
