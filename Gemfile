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

gem 'coveralls', :require => false, :group => :development
