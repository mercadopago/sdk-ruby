# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/lib/version"

Gem::Specification.new do |gem|
  gem.name          = 'mercadopago-sdk'
  gem.version       = MERCADO_PAGO_VERSION
  gem.authors       = %w[maticompiano]
  gem.email         = %w[matias.compiano@mercadolibre.com]
  gem.description   = 'MercadoPago Ruby SDK'
  gem.summary       = 'MercadoPago Ruby SDK'
  gem.homepage      = 'http://github.com/mercadopago/sdk-ruby'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^(tests)/})
  gem.require_paths = %w[lib]

  gem.add_dependency 'json'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
end
