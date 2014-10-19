# @author Manuel Dudda

%w(version crawler converter).each { |f| require "abrupt/#{f}" }

# This module is cool
# @abstract
module Abrupt
  def self.crawl(uri)
    crawler = Abrupt::Crawler.new uri
    crawler.crawl_site
  end
end
