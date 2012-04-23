# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lps/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Junegunn Choi"]
  gem.email         = ["junegunn.c@gmail.com"]
  gem.description   = %q{Rate-controlled loop execution}
  gem.summary       = %q{Rate-controlled loop execution}
  gem.homepage      = "https://github.com/junegunn/lps"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lps"
  gem.require_paths = ["lib"]
  gem.version       = LPS::VERSION

  gem.add_development_dependency 'test-unit'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-test'
end
