source 'https://rubygems.org'

# Specify your gem's dependencies in rawk_log.gemspec
gemspec

platforms :ruby_18 do
  gem 'rake', '< 11.0'
end
platforms :ruby_22, :ruby_23 do
  gem 'test-unit'
  gem 'minitest'
end

# mime-types 2.0 requires Ruby version >= 1.9.2
# mime-types 3.0 requires Ruby version >= 2.0
gem 'mime-types', RUBY_VERSION < '1.9.2' ? '< 2.0' : (defined?(JRUBY_VERSION) || RUBY_VERSION < '2.0' ? '< 3.0' : '>= 3.0')

gem 'coveralls', :require => false, :group => :development
