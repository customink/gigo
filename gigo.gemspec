# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gigo/version'

Gem::Specification.new do |gem|
  gem.name          = 'gigo'
  gem.version       = GIGO::VERSION
  gem.authors       = ["Ken Collins"]
  gem.email         = ["kcollins@customink.com"]
  gem.description   = 'Garbage in, garbage out. Fix ruby encoded strings at all costs.'
  gem.summary       = 'The gigo gem aims to solve bad data, likely from a legacy database. It is an anti-pattern and you should really consider standardizing what encoding you both put in and take out of your data stores.'
  gem.homepage      = 'http://github.com/customink/gigo'
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency     'activesupport', '>= 2.3'
  gem.add_runtime_dependency     'ensure_valid_encoding', '~> 0.5.3'
  gem.add_development_dependency 'appraisal'
  gem.add_development_dependency     'charlock_holmes', '~> 0.7'
  gem.add_development_dependency 'i18n' # Older ActiveSupport does not have a proper dep.
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
end
