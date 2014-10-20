# @author Manuel Dudda
require 'rest_client'
require 'addressable/uri'
%w(base readability subject input complexity picture link absolute_url).each do |f|
  require "abrupt/service/#{f}"
end
module Abrupt
  # Crawler for a website including all followed urls
  # with performing abrupt services
  class Crawler
    SERVICE_MAPPING = {
        r: {name: :readability, class: Abrupt::Service::Readability, options: ['lang']},
        i: {name: :input, class: Abrupt::Service::Input, options: []},
        s: {name: :subject, class: Abrupt::Service::Subject, options: %w(lang word_limit depth)},
        c: {name: :complexity, class: Abrupt::Service::Complexity, options: %w(adblock vicram vizweb color contrast ratio)},
        l: {name: :link, class: Abrupt::Service::Link, options: []},
        p: {name: :picture, class: Abrupt::Service::Picture, options: ['url']}
    }

    def initialize(uri, *args)
      @uri = Addressable::URI.parse(uri).normalize
      o = args.first
      @options = {lang: 'en', services: %w(r i s c l p)}
      @options[:services] = o[:services] if o[:services]
      @options[:lang] = o[:lang] if o[:lang]
      @result = {}
    end

    # Crawls the whole website
    def crawl_site
      uris_to_crawl = [@uri.to_str].to_set
      crawled_uris = Set.new
      until uris_to_crawl.empty?
        uris_to_crawl.each do |uri|
          new_uris = crawl(uri)
          crawled_uris << uri && uris_to_crawl.delete(uri)
          # add new uris
          new_uris.select! { |uri| same_host?(uri) }
          puts new_uris.inspect
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
      result = [uri]
      if @result[uri][:link]
        links_json = JSON.parse(@result[uri][:link])
        result += links_json['a'].map { |link| link['href'] } if links_json
      end
      result.to_set
    end

    def html?(content_type)
      content_type.start_with?('text/html')
    end

    def same_host?(uri)
      !uri.to_s.empty? && Addressable::URI.parse(uri).host.eql?(@uri.host)
    end

    def init_services_hash(html)
      @options[:services].map do |s|
        s = s.to_sym
        options = SERVICE_MAPPING[s][:options].map { |o| [o, @options[o]] }.to_h
        [SERVICE_MAPPING[s][:name], SERVICE_MAPPING[s][:class].new(html, options)]
      end.to_h
    end

    def canonize_html(html)
      begin
        baseurl = "#{@uri.scheme}://#{@uri.host}"
        converter = Abrupt::Service::AbsoluteUrl.new(html, baseurl: baseurl)
        converter.execute
      rescue
        puts "some problems with #{converter.url}"
      end
    end

    def perform_services(html)
      result = {}
      html = canonize_html(html)
      services_hash = init_services_hash(html)
      services_hash.each do |json_field, service_class|
        begin
          result[json_field] = service_class.execute
        rescue => e
          puts "some problems with #{service_class.url}"
          puts e
        end
      end
      result
    end
  end
end
