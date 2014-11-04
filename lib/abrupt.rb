# @author Manuel Dudda

%w(version crawler converter).each { |f| require "abrupt/#{f}" }

# This module is cool
# @abstract
module Abrupt
  def self.log(msg)
    print msg
  end

  def self.crawl(uri, *args)
    opts = args.first
    crawler = Abrupt::Crawler.new uri, opts
    start_time = Time.now
    Abrupt.log "begin: #{start_time}\n"
    result = crawler.crawl
    end_time = Time.now
    Abrupt.log "\nfinished in #{(end_time - start_time).round} sec.\n\n"
    case opts[:format]
    when 'xml'
      puts Abrupt::Converter.xml(result)
    else # owl as default
      puts Abrupt::Converter.owl(result)
    end
  end

  def self.convert(file, *args)
    puts args if 3 < 0
    hsh = Abrupt::Converter.from_xml(file)
    puts Abrupt::Converter.owl(hsh)
  end
end
