# @author Manuel Dudda
require 'rest_client'
%w(base readability subject input complexity picture link absolute_url).each do |f|
  require "abrupt/service/#{f}"
end
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
      puts @result.to_json
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
        @result[uri] = perform_services(response.to_str) if html?(content_type)
      else

      end
      # determine uris on this page
      # filter to only the same domain
      [uri]
    end

    def html?(content_type)
      content_type.start_with?('text/html')
    end

    def init_services_hash(html)
      {
          readability: Abrupt::Service::Readability.new(html, lang: @lang),
          input: Abrupt::Service::Input.new(html), # no options
          subject: Abrupt::Service::Subject.new(html,
                                                lang: @lang,
                                                word_limit: 20,
                                                depth: 3),
          complexity: Abrupt::Service::Complexity.new(html), # {adblock: true,
          # vicram: true, vizweb: true,color: true, contrast: true, ratio: true}
          link: Abrupt::Service::Link.new(html), # no options
          picture: Abrupt::Service::Picture.new(html) # {format: json}
      }
    end

    def canonize_html(html)
      u = URI(@uri)
      begin
        converter = Abrupt::Service::AbsoluteUrl.new(html, baseurl: "#{u.scheme}://#{u.host}")
        converter.execute
      rescue
        puts "some problems with #{converter.uri}"
      end
    end

    def perform_services(html)
      result = {}
      html = canonize_html(html)
      services_hash = init_services_hash(html)
      services_hash.each do |json_field, service_class|
        begin
          result[json_field] = service_class.execute
        rescue
          puts "some problems with #{service_class.uri}"
        end
      end
      result
    end
  end
end
