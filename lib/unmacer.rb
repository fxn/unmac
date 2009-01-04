require 'fileutils'

class Unmacer
  attr_accessor :verbose
  
  UNMAC_PER_DIRECTORY = [
    # In each folder the .DS_Store file stores info about Finder window settings
    # and Spotlight comments of its files.
    #
    # See http://en.wikipedia.org/wiki/.DS_Store.
    '.DS_Store',
  ]
  
  UNMAC_IN_ROOT_DIRECTORY = [
    # The FSEvents framework has a daemon that dumps events from /dev/fsevents
    # into log files stored in a .fseventsd directory at the root of the volume
    # the events are for.
    #
    # See http://arstechnica.com/reviews/os/mac-os-x-10-5.ars/7.
    '.fseventsd',
    
    # Spotlight saves all its index-related files in the .Spotlight-V100 directory
    # at the root level of a volume it has indexed.
    #
    # See http://www.thexlab.com/faqs/stopspotlightindex.html.
    '.Spotlight-V100',
  ]
    
  def initialize
    self.verbose = false
  end

private

  def delete!(file_or_directory)
    FileUtils.rm_r(file_or_directory)
  rescue Errno::ENOENT
    # ignore
  else
    puts "deleted #{file_or_directory}" if verbose
  end

  # Given the listing of a directory in +basenames+ this method selects emulated
  # resource forks in there.
  #
  # The resource fork of file "foo.txt" is emulated in a ghost file "._foo.txt".
  # This method returns the filenames that look like that. If +include_orphans+
  # is true any filename that starts with "._" is selected, otherwise we ensure
  # the corresponding filename exists in +basenames+.
  def select_emulated_resource_forks(basenames, include_orphans)
    basenames.select do |basename|
      basename =~ /\A\._(.*)/ && (include_orphans || basenames.include?($1))
    end
  end
end
