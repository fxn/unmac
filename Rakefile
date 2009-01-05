task :default => [:test]

task :test do
  Dir['test/test_*.rb'].each do |test|
    ruby "-Ilib #{test}"
  end
end
