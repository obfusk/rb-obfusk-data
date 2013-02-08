require File.expand_path('../lib/obfusk/data/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'obfusk-data'
  s.homepage    = 'https://github.com/obfusk/rb-obfusk-data'
  s.summary     = 'data validation combinator library for ruby'

  # s.description = <<-END.gsub(/^ {4}/, '')
  #   ...
  # END

  s.version     = Obfusk::Data::VERSION
  s.date        = Obfusk::Data::DATE

  s.authors     = [ 'Felix C. Stegerman' ]
  s.email       = %w{ flx@obfusk.net }

  s.licenses    = %w{ GPLv2 EPLv1 }

  s.files       = %w{ .yardopts README.md Rakefile *.gemspec } \
                + Dir['{lib,spec}/**/*.rb']

  s.add_runtime_dependency      'hamster'

  s.add_development_dependency  'rake'
  s.add_development_dependency  'rspec'

  s.required_ruby_version = '>= 1.9.1'
end
