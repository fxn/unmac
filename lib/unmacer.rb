require 'fileutils'
require 'find'

class Unmacer
  attr_accessor :verbose,
                :pretend,
                :keep_spotlight,
                :keep_fsevents,
                :keep_trashes,
                :keep_macosx,
                :keep_dsstore,
                :keep_apple_double,
                :keep_apple_double_orphans

  SPOTLIGHT = '.Spotlight-V100'
  FSEVENTS  = '.fseventsd'
  TRASHES   = '.Trashes'
  MACOSX    = '__MACOSX'
  DSSTORE   = '.DS_Store'

  def initialize
    self.verbose                   = false
    self.pretend                   = false
    self.keep_spotlight            = false
    self.keep_fsevents             = false
    self.keep_trashes              = false
    self.keep_macosx               = false
    self.keep_dsstore              = false
    self.keep_apple_double         = false
    self.keep_apple_double_orphans = false
  end

  def unmac!(dirnames)
    dirnames.each do |dirname|
      unmac_root(dirname)
      find_skipping_root(dirname) do |f|
        unmac_folder(f) if File.directory?(f)
      end
    end
  end

  def find_skipping_root(path)
    root_seen = false
    Find.find(path) do |f|
      if !root_seen
        root_seen = true
      else
        yield f
      end
    end
  end

private

  def unmac_root(dirname)
    # Order is important because ".Trashes" has "._.Trashes". Otherwise,
    # "._.Trashes" could be left as an orphan.
    unmac_folder(dirname)
    delete_spotlight(dirname) unless keep_spotlight
    delete_fsevents(dirname) unless keep_fsevents
    delete_trashes(dirname) unless keep_trashes
  end

  def unmac_folder(dirname)
    delete_macosx(dirname) unless keep_macosx
    delete_dsstore(dirname) unless keep_dsstore
    delete_apple_double(dirname) unless keep_apple_double
  end

  def delete(parent, file_or_directory)
    name = File.join(parent, file_or_directory)
    FileUtils.rm_r(name)
  rescue Errno::ENOENT
    # it does not exist, fine.
  else
    puts "deleted #{name}" if verbose
  end

  # Spotlight saves all its index-related files in the .Spotlight-V100 directory
  # at the root level of a volume it has indexed.
  #
  # See http://www.thexlab.com/faqs/stopspotlightindex.html.
  def delete_spotlight(dirname)
    delete(dirname, SPOTLIGHT)
  end

  # The FSEvents framework has a daemon that dumps events from /dev/fsevents
  # into log files stored in a .fseventsd directory at the root of the volume
  # the events are for.
  #
  # See http://arstechnica.com/reviews/os/mac-os-x-10-5.ars/7.
  def delete_fsevents(dirname)
    delete(dirname, FSEVENTS)
  end

  # A volume may have a ".Trashes" folder in the root directory. The Trash in
  # the Dock shows the contents of the ".Trash" folder in your home directory
  # and the content of all the ".Trashes/uid" in the rest of volumes.
  #
  # See http://discussions.apple.com/thread.jspa?messageID=1145130.
  def delete_trashes(dirname)
    delete(dirname, TRASHES)
  end

  # Apple's builtin Zip archiver stores some metadata in a directory called
  # "__MACOSX".
  #
  # See http://floatingsun.net/2007/02/07/whats-with-__macosx-in-zip-files.
  def delete_macosx(dirname)
    delete(dirname, MACOSX)
  end

  # In each directory the ".DS_Store" file stores info about Finder window
  # settings and Spotlight comments of its files.
  #
  # See http://en.wikipedia.org/wiki/.DS_Store.
  def delete_dsstore(dirname)
    delete(dirname, DSSTORE)
  end

  # When a file is copied to a volume that does not natively support HFS file
  # characteristics its data fork is stored under the file's regular name, and
  # the additional HFS information (resource fork, type & creator codes, etc.)
  # is stored in a second file in AppleDouble format, with a name that starts
  # with "._". So if the original file is called "foo.txt" you get a spurious
  # ghost file called "._foo.txt".
  #
  # If you drag & drop a file onto a Windows partition, or you unpack a tarball
  # on Linux that was built with Apple's tar(1) archiver you'll get that extra
  # stuff. Reason is if the tarball is extracted into another Mac the metadata
  # is preserved with this hack.
  #
  # See http://www.westwind.com/reference/OS-X/invisibles.html.
  # See http://en.wikipedia.org/wiki/Resource_fork.
  # See http://en.wikipedia.org/wiki/AppleSingle.
  def delete_apple_double(dirname)
    basenames = Dir.entries(dirname)
    basenames.select do |basename|
      basename =~ /\A\._(.*)/ &&
      !keep_apple_double_orphans ||
      basenames.include?($1)
    end.each do |basename|
      delete(dirname, basename)
    end
  end
end
