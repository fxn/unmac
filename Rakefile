require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = Dir.glob('test/test_*.rb')
  t.verbose = true
end

task :readme do
  system "ruby -Ilib bin/unmac > README"
end
