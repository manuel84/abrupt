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

# Extension for all objects
class Object
  def ensure_to_a
    [self].flatten.compact
  end
end

# This module is cool
# @abstract
module Abrupt
  VOC = RDF::Vocabulary.new('http://wba.cs.hs-rm.de/AbRUPt/')
  VOC_FILE = File.join File.dirname(__dir__), 'assets', 'voc', 'tbox.ttl'
  RULES_DIR = File.join File.dirname(__dir__), 'assets', 'rules', '*'
  DELIMITER = '/'
  PREFIXES = {
      abrupt: VOC.to_s,
      rdf: RDF.to_s,
      rdfs: RDF::RDFS.to_s,
      xsd: RDF::XSD.to_s,
      owl: RDF::OWL.to_s
  }

  TIME_INPUT_FORMAT = '%d/%b/%Y:%H:%M:%S'
  TIME_OUTPUT_FORMAT = '%Y-%m-%d_%H%M%S'

  def self.parse_time(time)
    DateTime.strptime(time, TIME_INPUT_FORMAT)
  end

  def self.format_time(time)
    parse_time(time).strftime(TIME_OUTPUT_FORMAT)
  end

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
    converter = Converter.instance
    converter.init(args[1])
    # converter.append_website_data(file)
    converter.append_user_data(args.first) if args.first
    # converter.append_rules
    converter.result
  end
end
