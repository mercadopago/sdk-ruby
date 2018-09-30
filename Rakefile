require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/lib/*.rb']
  t.verbose = true
end

task :default => :test
