#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Build outside the checkout so the manifest cannot depend on Git metadata.
cp -R "$root/lib" "$root/mercadopago.gemspec" "$root/README.md" "$root/LICENSE.txt" "$root/CHANGELOG.md" "$tmpdir/"
cd "$tmpdir"
gem build mercadopago.gemspec
version=$(ruby -e 'puts Gem::Specification.load("mercadopago.gemspec").version')
gem_file="$tmpdir/mercadopago-sdk-$version.gem"

ruby -rrubygems/package -e '
  files = Gem::Package.new(ARGV.fetch(0)).spec.files
  expected = Dir.glob("lib/**/*").select { |path| File.file?(path) }
  abort "Library entry point missing from source" unless expected.include?("lib/mercadopago.rb")
  missing = expected - files
  abort "Library files missing from gem: #{missing.join(", ")}" unless missing.empty?
' "$gem_file"

# Install and load the built artifact without access to the checkout or user gems.
export GEM_HOME="$tmpdir/gems"
export GEM_PATH="$GEM_HOME"
unset RUBYOPT BUNDLE_GEMFILE BUNDLE_PATH
gem install --no-document --install-dir "$GEM_HOME" "$gem_file"
mkdir "$tmpdir/empty"
cd "$tmpdir/empty"
ruby -e '
  require "mercadopago"
  spec = Gem.loaded_specs.fetch("mercadopago-sdk")
  abort "Loaded wrong gem version: #{spec.version}" unless spec.version.to_s == ARGV.fetch(0)
  abort "Loaded gem outside isolated directory" unless File.realpath(spec.full_gem_path).start_with?(File.realpath(ARGV.fetch(1)) + "/")
' "$version" "$GEM_HOME"

# Publish exactly the artifact that was installed and checked above.
cp "$gem_file" "$root/mercadopago-sdk-$version.gem"
