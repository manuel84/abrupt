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

    # Crawls a page, saves the service results in result hash
    # and returns an array with the existing uris of this page.
    #
    # @param uri [String] the uri to crawl
    # @return [JSON] result
    def crawl(uri = nil, follow_links = true)
      uri ||= @uri.to_str
      unless @result[uri]
        html = fetch_html(uri)
        @result[uri] ||= {}
        @result[uri] = perform_services(html) if html
        # determine uris on this page
        new_uris = []
        if @result[uri][:link]
          links_json = JSON.parse(@result[uri][:link])
          new_uris += links_json['a'].map { |link| link['href'] } if links_json
        end
        new_uris.select! { |uri| same_host?(uri) } # filter
        new_uris.uniq.each { |uri| crawl(uri, follow_links) } if follow_links
      end
      @result.to_json
    end

    def fetch_html(uri)
      begin
        response = ::RestClient.get Addressable::URI.parse(uri.strip).normalize.to_str, {accept: :html}
        content_type = response.headers[:content_type].to_s
        case response.code
        when 200...400
          response.to_str if html?(content_type)
        else
          false
        end
      rescue => e
        puts "error fetching html on #{uri}"
        puts e
        nil
      end
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
