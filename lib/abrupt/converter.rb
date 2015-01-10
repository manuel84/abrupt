# @author Manuel Dudda
require 'singleton'
require 'rest_client'
require 'gyoku'
require 'rdf'
require 'linkeddata'
require 'active_support/core_ext'
Dir[File.dirname(__FILE__) + '/transformation/*.rb',
    File.dirname(__FILE__) + '/transformation/website/*.rb',
    File.dirname(__FILE__) + '/transformation/client/*.rb'].each do |file|
  require file
end

# Abrupt Converter
module Abrupt
  # Converter
  class Converter
    include Singleton
    include RDF
    attr_accessor :hsh, :values, :result, :format

    def init(hsh, options = {})
      @format = options[:format].try(:to_sym) || :turtle
      init_hsh(hsh)
      @result = Repository.load(VOC_FILE)
      domain = RDF::URI("#{VOC}Website/#{@hsh[:website][:domain]}")
      @result << Statement.new(domain, RDF.type, VOC.Website)
      @result << Statement.new(domain, VOC.hostName, domain.host)
      perform
    end

    def init_hsh(hsh)
      hsh = from_xml(hsh) unless hsh.is_a?(Hash)
      @hsh = hsh.deep_symbolize_keys
      return unless @hsh[:website]
      @hsh[:website][:url].each_with_index do |value, i|
        website_transformations.each do |transformation_class|
          @hsh[:website][:url][i] =
              transformation_class.customize_to_schema(value)
        end
      end
    end

    def self.xml(hsh)
      Gyoku.xml hsh
    end

    def self.json(hsh)
      hsh.to_json
    end

    def website_transformations
      Transformation::Website::Base.subclasses
    end

    def client_transformations
      Transformation::Client::Base.subclasses
    end

    def from_xml(file)
      xml = Nokogiri::XML(File.read(file))
      Hash.from_xml(xml.to_s)
    end

    def add_to_result(statements)
      statements.each do |stmt|
        @result << stmt
      end
    end

    def perform
      website = ['Website', @hsh[:website][:domain]]
      @hsh[:website][:url].each do |url|
        page = ['Page', url[:name].append_last_slash]
        page_transformator = Transformation::Base.new(website, page)
        add_to_result page_transformator.add_individuals # add Page
        next unless url[:state]
        perform_states url[:state], website + page
      end
    end

    def perform_states(states, parent_uri)
      states = states.is_a?(Array) ? states : [states]
      states.each do |value|
        state = ['State', value[:name]]
        state_uri = parent_uri + state
        # MAYBE empty?
        add_to_result Transformation::Base.new(parent_uri, state).result
        website_transformations.each do |transformation_class|
          t = transformation_class.new(state_uri, nil, value)
          add_to_result t.add_individuals
        end
      end
    end

    def append_user_data(file)
      return unless file.is_a?(String) && File.exist?(file)
      xml = Nokogiri::XML(File.read(file))
      xml.css('visitor').each do |values|
        ip = values.css('ip').text
        next unless ip
        visitor = Transformation::Client::Visitor.new(
            ['Website', @hsh[:website][:domain]],
            ['Visitor', ip], values)
        add_to_result visitor.add_individuals
        append_pages_for_visitor(visitor)
      end
      @result
    end

    def append_pages_for_visitor(visitor)
      visitor.values.css('pages page').each do |page|
        client_transformations.each do |transformation_class|
          time = page.css('entertime').text
          url_time = ::Abrupt.format_time(time)
          transformator = transformation_class.new(
              visitor.parent_uri + visitor.uri,
              ['Visit', url_time], page
          )
          add_to_result transformator.add_individuals
        end
      end
    end

    def append_rules
      Dir.glob(RULES_DIR).each do |rule_directory|
        Dir.glob(File.join(rule_directory, '*')).each do |rule_file|
          rule = Repository.load(rule_file)
          add_to_result(rule.statements)
        end
      end
    end
  end
end
