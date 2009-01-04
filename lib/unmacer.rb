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

  def delete!(file_or_directory)
    FileUtils.rm_r(file_or_directory)
  rescue Errno::ENOENT
    # ignore
  else
    puts "deleted #{file_or_directory}" if verbose
  end

  def select_emulated_resource_forks(listing)
    listing.select do |filename|
      filename =~ /^\._(.*)/ && listing.include?($1)
    end
  end
end