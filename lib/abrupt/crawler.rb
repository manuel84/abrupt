# @author Manuel Dudda
require 'rest_client'
require 'addressable/uri'
%w( base
    readability
    subject
    input
    complexity
    picture
    link
    absolute_url).each do |f|
  require_relative "service/#{f}"
end
module Abrupt
  # Crawler for a website including all followed urls
  # with performing abrupt services
  # BETA!!!
  class Crawler
    SERVICE_MAPPING = {
        r: Service::Readability,
        i: Service::Input,
        s: Service::Subject,
        c: Service::Complexity,
        l: Service::Link,
        p: Service::Picture
    }

    def initialize(uri, *args)
      @uri = Addressable::URI.parse(uri).normalize
      opts = args.first
      @options = {
          lang: 'en',
          services: %w(r i s c l p),
          depth: '3',
          word_limit: 20
      }
      @options[:services] = opts[:services] if opts[:services]
      @options[:lang] = opts[:lang] if opts[:lang]
      @follow_links = !opts[:nofollow]
      @result = {}
    end

    # Crawls a page, saves the service results in result hash
    # and returns an array with the existing uris of this page.
    #
    # @param uri [String] the uri to crawl
    # @return [JSON] result
    def crawl(uri = nil)
      Abrupt.log '.'
      uri ||= @uri.to_str.append_last_slash
      unless @result[uri]
        html = fetch_html(uri)
        @result[uri] ||= {}
        @result[uri] = perform_services(html) if html
        # new_uris.select! { |url| same_host?(url) } # filter
        uris_with_same_host(uri).uniq.each { |url| crawl(url) } if @follow_links
      end
      Service::Base.transform_hash(@result)
    end

    # TODO: maybe as class method
    def uris_with_same_host(uri)
      if @result[uri][:link] && @result[uri][:link]['a']
        @result[uri][:link]['a'].to_a.map do |link|
          link['href'] if same_host?(link['href'])
        end.compact
      else
        []
      end
    end

    def fetch_html(uri)
      uri = Addressable::URI.parse(uri.strip).normalize.to_str
      begin
        response = ::RestClient.get uri, accept: :html
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
        service_class = SERVICE_MAPPING[s]
        available_options = service_class.available_options
        opts = available_options.map { |o| [o, @options[o.to_sym]] }.to_h
        service = service_class.new(html, opts)
        [service_class.keyname, service]
      end.to_h
    end

    def canonize_html(html)
      baseurl = "#{@uri.scheme}://#{@uri.host}"
      converter = Service::AbsoluteUrl.new(html, baseurl: baseurl)
      converter.execute
    end

    def perform_services(html)
      result = {}
      html = canonize_html(html)
      services_hash = init_services_hash(html)
      services_hash.each do |json_field, service_class|
        result[json_field.to_sym] = service_class.execute
      end
      result
    end
  end
end
