require 'fileutils'

class Unmacer
  attr_accessor :verbose, :keep_apple_double_orphans
  
  def initialize
    self.verbose                   = false
    self.keep_apple_double_orphans = false
  end

  def unmac!(*directories)
    directories.each do |directory|
      Dir.chdir(directory) do
        delete_all
      end
    end
  end

private

  def delete_all
    delete_in_arbitrary_folder
    delete_in_root_folder
  end

  def delete_in_root_folder
    delete_spotlight
    delete_fseventsd
    delete_trashes
  end
  
  def delete_in_arbitrary_folder
    delete_macosx
    delete_ds_store
    delete_apple_double_hidden_files
  end

  def delete(file_or_directory)
    FileUtils.rm_r(file_or_directory)
  rescue Errno::ENOENT
    # ignore
  else
    puts "deleted #{file_or_directory}" if verbose
  end

  # Spotlight saves all its index-related files in the .Spotlight-V100 directory
  # at the root level of a volume it has indexed.
  #
  # See http://www.thexlab.com/faqs/stopspotlightindex.html.
  def delete_spotlight
    delete('.Spotlight-V100')
  end

  # The FSEvents framework has a daemon that dumps events from /dev/fsevents
  # into log files stored in a .fseventsd directory at the root of the volume
  # the events are for.
  #
  # See http://arstechnica.com/reviews/os/mac-os-x-10-5.ars/7.
  def delete_fseventsd
    delete('.fseventsd')
  end

  # A volume may have a ".Trashes" folder in the root directory. The Trash in
  # the Dock shows the contents of the ".Trash" folder in your home directory
  # and the content of all the ".Trashes/user_id" in the rest of volumes.
  #
  # See http://discussions.apple.com/thread.jspa?messageID=1145130.
  def delete_trashes
    delete('.Trashes')
  end

  # Apple's builtin Zip archiver stores some metadata in a directory called
  # "__MACOSX".
  #
  # See http://floatingsun.net/2007/02/07/whats-with-__macosx-in-zip-files.
  def delete_macosx
    delete('__MACOSX')
  end

  # In each directory the ".DS_Store" file stores info about Finder window
  # settings and Spotlight comments of its files.
  #
  # See http://en.wikipedia.org/wiki/.DS_Store.
  def delete_ds_store
    delete('.DS_Store')
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
  #
  # Given the listing of a directory in +basenames+ this method selects
  # emulated resource forks in there.
  #
  # If +include_orphans+ is true any filename that start with "._" are
  # selected. The idea is to clean up ghost entries corresponding to files
  # that were deleted in the target volume mounted in a different OS.
  # Otherwise we ensure the corresponding filename exists in +basenames+.
  def delete_apple_double_hidden_files
    Dir.foreach('.') do |basename|
      delete(basename) if basename =~ /\A\._(.*)/ &&
                          !keep_apple_double_orphans ||
                          basenames.include?($1)
    end
  end
end
