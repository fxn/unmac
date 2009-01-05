Gem::Specification.new do |spec|
  spec.name              = 'unmac'
  spec.version           = '0.1'
  spec.summary           = 'Delete spurious Mac files under a directory or volume'
  spec.homepage          = 'http://github.com/fxn/unmac/tree/master'
  spec.executables       = %w(unmac)
  spec.author            = 'Xavier Noria'
  spec.email             = 'fxn@hashref.com'
  spec.rubyforge_project = 'unmac'

  spec.files = %w(
    unmac.gemspec
    Rakefile
    README
    MIT-LICENSE
    bin/unmac
    lib/unmacer.rb
    test/test_unmacer.rb
    test/test_unmac.rb
  )

  spec.test_files = Dir.glob('test/test_*.rb')
end