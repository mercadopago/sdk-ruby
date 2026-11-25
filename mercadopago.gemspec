# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.name                  = 'mercadopago-sdk'
  gem.version               = '3.5.2'
  gem.required_ruby_version = '>= 3.3.0'
  gem.author                = 'Mercado Pago'
  gem.description           = 'Mercado Pago Ruby SDK'
  gem.summary               = 'Mercado Pago Ruby SDK'
  gem.homepage              = 'http://github.com/mercadopago/sdk-ruby'
  gem.license               = 'MIT'

  gem.files         = Dir['lib/**/*'].select { |path| File.file?(path) } + %w[LICENSE.txt README.md CHANGELOG.md]
  gem.test_files    = gem.files.grep(%r{^(tests)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'faraday', '~>2.0'
  gem.add_dependency 'json', '~>2.5'
  gem.add_development_dependency 'pry', '~>0.14'
  gem.add_development_dependency 'rake', '~>13.0'
end
