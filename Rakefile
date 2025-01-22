# frozen_string_literal: true

require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/tests.rb']
  t.verbose = true
end

task default: :test
