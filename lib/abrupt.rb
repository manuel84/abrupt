# @author Manuel Dudda

%w(version crawler converter).each { |f| require "abrupt/#{f}" }

# This module is cool
# @abstract
module Abrupt
  def self.crawl(uri, *args)
    crawler = Abrupt::Crawler.new uri, args.first
    crawler.crawl_site
  end
end
