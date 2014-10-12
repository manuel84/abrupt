require 'rest_client'
require 'abrupt/service/readability'

module Abrupt
  class Crawler
    def initialize(uri, lang='en')
      @uri = uri
      @lang = lang
      @result = {}
    end

    # Crawls the whole website
    def crawl_site
      # begin with 1 uri
      uris_to_crawl = [@uri].to_set

      crawled_uris = Set.new

      until uris_to_crawl.empty?
        uris_to_crawl.each do |uri|
          puts "crawl #{uri}"
          new_uris = crawl(uri)
          crawled_uris << uri
          uris_to_crawl.delete uri
          # add new uris
          uris_to_crawl.merge(new_uris.select { |u| !crawled_uris.include?(u) })
        end
        puts "----"
        puts uris_to_crawl.inspect
        puts crawled_uris.inspect
      end
      puts @result
    end

    # Crawls a page, saves the service results in result hash and returns an array with the existing uris of this page.
    #
    # @param uri [String] the uri to crawl
    # @return [Array] available uris on this page
    def crawl(uri)
      response = ::RestClient.get uri
      puts response.code
      puts response.headers
      if (200..400).include?(response.code) && response.headers[:content_type].to_s.start_with?('text/html')
        puts "start"
        html = response.to_str
        @result[uri] ||= {}
        #Readability
        service = Abrupt::Service::Readability.new(html)
        @result[uri][:readability] = service.execute
      end
      # determine uris on this page
      # filter to only the same domain
      [uri]
    end
  end
end