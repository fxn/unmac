require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = Dir.glob('test/test_*.rb')
  t.verbose = true
end

task :home do
  sh "scp home/index.html fxn@rubyforge.org:/var/www/gforge-projects/unmac/"
end
