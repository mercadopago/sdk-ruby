# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.name                  = 'mercadopago-sdk'
  gem.version               = '2.0.1'
  gem.required_ruby_version = '>= 2.3.0'
  gem.author                = 'Mercado Pago'
  gem.description           = 'Mercado Pago Ruby SDK'
  gem.summary               = 'Mercado Pago Ruby SDK'
  gem.homepage              = 'http://github.com/mercadopago/sdk-ruby'
  gem.license               = 'MIT'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^(tests)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'json'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
end
