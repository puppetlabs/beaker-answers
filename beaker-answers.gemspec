# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'beaker-answers/version'

Gem::Specification.new do |s|
  s.name        = "beaker-answers"
  s.version     = BeakerAnswers::Version::STRING
  s.authors     = ["Puppetlabs", "anode"]
  s.email       = ["qe-team@puppetlabs.com"]
  s.homepage    = "https://github.com/puppetlabs/beaker-answers"
  s.summary     = %q{Answer generation for PE Installation!}
  s.description = %q{For use for the Beaker acceptance testing tool}
  s.license     = 'Apache2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Testing dependencies
  s.add_development_dependency 'fakefs', '~> 2.5'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rubocop', '~> 1.53'
  s.add_development_dependency 'rubocop-rspec', '~> 2.29'
  s.add_development_dependency 'simplecov', '~> 0.22.0'

  # Documentation dependencies
  s.add_development_dependency 'yard'
  s.add_development_dependency 'thin'

  # Run time dependencies
  s.add_runtime_dependency 'stringify-hash', '~> 0.0.0'
  s.add_runtime_dependency 'require_all', '>= 1.3.2', '< 3.1.0'
  s.add_runtime_dependency 'hocon', '~> 1.0'

end
