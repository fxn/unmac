$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'fileutils'
require 'set'
require 'unmacer'
require 'test/unit'

TEST_DIR = File.expand_path(File.dirname(__FILE__))
TMP_DIR  = File.join(TEST_DIR, 'tmp')

class TestUnmacer < Test::Unit::TestCase
  def in_test_dir
    Dir.chdir(TEST_DIR) { yield }
  end

  def in_tmp_dir
    Dir.chdir(TMP_DIR) { yield }
  end

  def setup
    in_test_dir { Dir.mkdir('tmp') }
    @unmacer = Unmacer.new
  end

  def teardown
    in_test_dir { FileUtils.rm_r('tmp') }
  end

  def unmac!
    @unmacer.unmac!(TMP_DIR)
  end

  def create_struct(dirnames=[], fnames=[])
    in_tmp_dir do
      FileUtils.mkdir_p([*dirnames])
      FileUtils.touch([*fnames])
    end
  end

  def read_struct
    entries = []
    in_tmp_dir do
      @unmacer.find_skipping_root('.') do |f|
        # File.find returns "./foo.txt", remove the leading stuff.
        entries << f.sub(%r{\A\.[/\\]}, '')
      end
    end
    entries
  end

  def test_an_empty_directory_should_remain_empty
    create_struct
    unmac!
    assert read_struct.empty?
  end

  def test_spotlight
    create_struct(Unmacer::SPOTLIGHT)
    unmac!
    assert read_struct.empty?
  end

  def test_keep_spotlight
    create_struct(Unmacer::SPOTLIGHT)
    @unmacer.keep_spotlight = true
    unmac!
    assert [Unmacer::SPOTLIGHT], read_struct
  end

  def test_fsevents
    create_struct(Unmacer::FSEVENTS)
    unmac!
    assert read_struct.empty?
  end

  def test_keep_fsevents
    create_struct(Unmacer::FSEVENTS)
    @unmacer.keep_fsevents = true
    unmac!
    assert [Unmacer::FSEVENTS], read_struct
  end

  def test_trashes
    create_struct(Unmacer::TRASHES)
    unmac!
    assert read_struct.empty?
  end

  def test_keep_trashes
    create_struct(Unmacer::TRASHES)
    @unmacer.keep_trashes = true
    unmac!
    assert_equal [Unmacer::TRASHES], read_struct
  end

  def test_macosx
    create_struct(Unmacer::MACOSX)
    unmac!
    assert read_struct.empty?
  end

  def test_keep_macosx
    create_struct(Unmacer::MACOSX)
    @unmacer.keep_macosx
    unmac!
    assert [Unmacer::MACOSX], read_struct
  end

  def test_dsstore
    create_struct([], Unmacer::DSSTORE)
    unmac!
    assert read_struct.empty?
  end

  def test_apple_double_with_pair
    create_struct([], %w(foo.txt ._foo.txt))
    unmac!
    assert_equal %w(foo.txt), read_struct
  end

  def test_keep_apple_double_with_pair
    create_struct([], %w(foo.txt ._foo.txt))
    @unmacer.keep_apple_double = true
    unmac!
    assert_equal Set.new(%w(foo.txt ._foo.txt)), Set.new(read_struct)
  end

  def test_apple_double_with_orphan
    create_struct([], '._foo.txt')
    unmac!
    assert read_struct.empty?
  end

  def test_keep_apple_double_with_orphan
    create_struct([], '._foo.txt')
    @unmacer.keep_apple_double = true
    unmac!
    assert ['._foo.txt'], read_struct
  end

  def test_assert_keep_apple_double_orphans
    create_struct([], '._foo.txt')
    @unmacer.keep_apple_double_orphans = true
    unmac!
    assert_equal %w(._foo.txt), read_struct
  end
end
