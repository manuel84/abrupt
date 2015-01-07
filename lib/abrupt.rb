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

  def append_last_slash
    gsub(/([^\/])$/, '\1/')
  end
end

# This module is cool
# @abstract
module Abrupt
  WDM = RDF::Vocabulary.new('http://wba.cs.hs-rm.de/wdm-service/wdmOWL/')
  VOC_FILE = File.join File.dirname(__dir__), 'assets', 'voc', 'wdm.ttl'
  RULES_DIR = File.join File.dirname(__dir__), 'assets', 'rules', '*'
  DELIMITER = '#'
  PREFIXES = {
      wdm: WDM.to_s,
      rdf: RDF.to_s,
      rdfs: RDF::RDFS.to_s,
      xsd: RDF::XSD.to_s,
      owl: RDF::OWL.to_s
  }

  def self.root
    File.dirname __dir__
  end

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
    converter = Converter.new(file, args[1])
    converter.append_user_data(args.first) if args.first
    converter.append_rules
    puts converter.owl
  end
end
