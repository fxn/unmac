task :default => [:test]

task :test do
  Dir['test/test_*.rb'].each do |test|
    ruby "-Ilib #{test}"
  end
end

task :home do
  sh "scp home/index.html fxn@rubyforge.org:/var/www/gforge-projects/unmac/"
end
