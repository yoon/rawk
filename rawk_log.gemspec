# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rawk_log/version'

Gem::Specification.new do |spec|
  spec.name          = "rawk_log"
  spec.version       = RawkLog::VERSION
  spec.authors       = ["Chris Hobbs", "Ian Heggie"]
  spec.email         = ["chris.hobbs@unknown.due.to.spam", "ian@heggie.biz"]
  spec.description   = %q{RawkLog - RAWK - Rail's Analyzer With Klass updated and packaged a Gem}
  spec.summary       = %q{This tool gives statistics for Ruby on Rails log files. The times for each request are grouped and totals are displayed. If process ids are present in the log files then requests are sorted by ActionController actions otherwise requests are grouped by url. By default total request times are used for comparison but database time or render time can be used by specifying the correct flag. The log file is read from standard input unless the -f flag is specified.}
  spec.homepage      = "https://github.com/ianheggie/rawk_log"
  spec.license       = "Beerware"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
