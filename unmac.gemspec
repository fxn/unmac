Gem::Specification.new do |spec|
  spec.name              = 'unmac'
  spec.version           = '0.2'
  spec.summary           = 'Delete spurious Mac files under a directory or volume'
  spec.homepage          = 'http://github.com/fxn/unmac/tree/master'
  spec.executables       = %w(unmac)
  spec.author            = 'Xavier Noria'
  spec.email             = 'fxn@hashref.com'
  spec.rubyforge_project = 'unmac'

  spec.test_files = %w(
    test/test_unmacer.rb
    test/test_unmac.rb    
  )

  spec.files = %w(
    unmac.gemspec
    Rakefile
    README
    MIT-LICENSE
    bin/unmac
    lib/unmacer.rb
  ) + spec.test_files
end