# @author Manuel Dudda
require 'rest_client'
require 'abrupt/service/readability'
module Abrupt
  # Crawler for a website including all followed urls
  # with performing abrupt services
  class Crawler
    def initialize(uri, lang = 'en')
      @uri = uri
      @lang = lang
      @result = {}
    end

    # Crawls the whole website
    def crawl_site
      uris_to_crawl = [@uri].to_set
      crawled_uris = Set.new
      until uris_to_crawl.empty?
        uris_to_crawl.each do |uri|
          new_uris = crawl(uri)
          crawled_uris << uri && uris_to_crawl.delete(uri)
          # add new uris
          uris_to_crawl.merge(new_uris.select { |u| !crawled_uris.include?(u) })
        end
      end
      puts @result
    end

    # Crawls a page, saves the service results in result hash
    # and returns an array with the existing uris of this page.
    #
    # @param uri [String] the uri to crawl
    # @return [Array] available uris on this page
    def crawl(uri)
      response = ::RestClient.get uri
      content_type = response.headers[:content_type].to_s
      case response.code
      when 200...400
        @result[uri] ||= {}
        @result[uri] = perform_services response.to_str if html?(content_type)
      else

      end
      # determine uris on this page
      # filter to only the same domain
      [uri]
    end

    def html?(content_type)
      content_type.start_with?('text/html')
    end

    def perform_services(html)
      result = {}
      {
          readability: Abrupt::Service::Readability.new(html),
          complexity: Abrupt::Service::Complexity.new(html)
      }.each do |json_field, service_class|
        result[json_field] = service_class.execute
      end
      result
    end
  end
end
