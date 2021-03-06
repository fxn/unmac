require 'stringio'
require 'unmacer'
require 'test/unit'

UNMAC_RB  = File.join(File.dirname(__FILE__), '..', 'bin', 'unmac')
UNMAC_SRC = File.open(UNMAC_RB) { |f| f.read }

class TestUnmac < Test::Unit::TestCase
  def call_unmac(*args)
    ARGV.clear
    ARGV.concat(['--test', *args])
    eval UNMAC_SRC
  end

  def test_no_options
    unmacer = call_unmac('dummy')
    assert !unmacer.verbose
    assert !unmacer.pretend
    assert !unmacer.keep_spotlight
    assert !unmacer.keep_fsevents
    assert !unmacer.keep_trashes
    assert !unmacer.keep_document_revisions
    assert !unmacer.keep_mobile_backups
    assert !unmacer.keep_macosx
    assert !unmacer.keep_dsstore
    assert !unmacer.keep_apple_double
    assert !unmacer.keep_apple_double_orphans
    assert !unmacer.keep_custom_folder_icons
    assert_equal %w(dummy), ARGV
  end

  def test_verbose
    for opt in ['--verbose', '-v']
      unmacer = call_unmac(opt, 'dummy')
      assert unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_pretend
    for opt in ['--pretend', '-p']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_spotlight
    for opt in ['--keep-spotlight', '-s']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_fsevents
    for opt in ['--keep-fsevents', '-f']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_trashes
    for opt in ['--keep-trashes', '-t']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_document_revisions
    for opt in ['--keep-document-revisions', '-c']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_macosx
    for opt in ['--keep-macosx', '-m']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_dsstore
    for opt in ['--keep-dsstore', '-r']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_apple_double
    for opt in ['--keep-apple-double', '-d']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_apple_double_orphans
    for opt in ['--keep-apple-double-orphans', '-o']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert unmacer.keep_apple_double_orphans
      assert !unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_custom_folder_icons
    for opt in ['--keep-custom-folder-icons', '-i']
      unmacer = call_unmac(opt, 'dummy')
      assert !unmacer.verbose
      assert !unmacer.pretend
      assert !unmacer.keep_spotlight
      assert !unmacer.keep_fsevents
      assert !unmacer.keep_trashes
      assert !unmacer.keep_document_revisions
      assert !unmacer.keep_mobile_backups
      assert !unmacer.keep_macosx
      assert !unmacer.keep_dsstore
      assert !unmacer.keep_apple_double
      assert !unmacer.keep_apple_double_orphans
      assert unmacer.keep_custom_folder_icons
      assert_equal %w(dummy), ARGV
    end
  end

  def test_mix_1
    unmacer = call_unmac(*%w(-v -f -m -d -i dummy))
    assert unmacer.verbose
    assert !unmacer.pretend
    assert !unmacer.keep_spotlight
    assert unmacer.keep_fsevents
    assert !unmacer.keep_trashes
    assert !unmacer.keep_document_revisions
    assert !unmacer.keep_mobile_backups
    assert unmacer.keep_macosx
    assert !unmacer.keep_dsstore
    assert unmacer.keep_apple_double
    assert !unmacer.keep_apple_double_orphans
    assert unmacer.keep_custom_folder_icons
    assert_equal %w(dummy), ARGV
  end

  def test_mix_2
    unmacer = call_unmac(*%w(-s -t -r -o dummy))
    assert !unmacer.verbose
    assert !unmacer.pretend
    assert unmacer.keep_spotlight
    assert !unmacer.keep_fsevents
    assert unmacer.keep_trashes
    assert !unmacer.keep_document_revisions
    assert !unmacer.keep_mobile_backups
    assert !unmacer.keep_macosx
    assert unmacer.keep_dsstore
    assert !unmacer.keep_apple_double
    assert unmacer.keep_apple_double_orphans
    assert !unmacer.keep_custom_folder_icons
    assert_equal %w(dummy), ARGV
  end

  def test_help
    buf = ''
    $> = StringIO.open(buf, 'w')
    call_unmac('-h')
    $> = $stdout
    assert_match %r{^unmac\b}, buf
    assert_match %r{^Usage\b}, buf
    assert ARGV.empty?
  end

  def test_no_directory
    buf = ''
    $> = StringIO.open(buf, 'w')
    call_unmac
    $> = $stdout
    assert_match %r{^unmac\b}, buf
    assert_match %r{^Usage\b}, buf
  end
end
