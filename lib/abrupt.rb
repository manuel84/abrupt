# @author Manuel Dudda

%w(version crawler converter).each { |f| require "abrupt/#{f}" }

# This module is cool
# @abstract
module Abrupt
  def self.log(msg)
    print msg
  end

  def self.crawl(uri, *args)
    crawler = Abrupt::Crawler.new uri, args.first
    start_time = Time.now
    Abrupt.log "begin: #{start_time}\n"
    result = crawler.crawl
    end_time = Time.now
    Abrupt.log "\nfinished in #{(end_time - start_time).round} sec.\n\n"
    puts result.to_xml
  end
end
