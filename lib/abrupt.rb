# @author Manuel Dudda
Dir[File.dirname(__FILE__) + '/abrupt/*.rb'].each do |file|
  require file
end
require 'pp'

# Extension for String class
class String
  def remove_last_slashes
    gsub(/([\/]*)$/, '')
  end
end

# This module is cool
# @abstract
module Abrupt
  WDM = RDF::Vocabulary.new('http://wba.cs.hs-rm.de/wdm-service/wdmOWL/')
  DELIMITER = '#'

  def self.log(msg)
    print msg
  end

  def self.crawl(uri, *args)
    opts = args.first
    crawler = Abrupt::Crawler.new uri, opts
    start_time = Time.now
    log "begin: #{start_time}\n"
    result = crawler.crawl
    end_time = Time.now
    log "\nfinished in #{(end_time - start_time).round} sec.\n\n"
    case opts[:format]
    when 'xml'
      puts Converter.xml(result)
    else # owl as default
      puts Converter.owl(result)
    end
  end

  def self.convert(file, *args)
    puts args if 3 < 0
    hsh = Converter.from_xml(file)
    converter = Converter.new(hsh)
    converter.append_user_data(args.first) if args.first
    puts converter.owl
  end
end
