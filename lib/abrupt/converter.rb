# @author Manuel Dudda
require 'rest_client'
require 'gyoku'
require 'rdf'
require 'linkeddata'
require 'active_support/core_ext/hash'
Dir[File.dirname(__FILE__) + '/transformation/*.rb',
    File.dirname(__FILE__) + '/transformation/website/*.rb',
    File.dirname(__FILE__) + '/transformation/client/*.rb'].each do |file|
  require file
end

# Abrupt Converter
module Abrupt
  # Converter
  class Converter
    include RDF
    TRANSFORMATIONS =
        [Transformation::Website::Readability,
         Transformation::Website::Input,
         Transformation::Website::Subject,
         Transformation::Website::Complexity,
         Transformation::Website::Link,
         Transformation::Website::Picture]

    attr_accessor :hsh, :values, :result, :format

    def initialize(hsh, options)
      @format = options[:format].to_sym || :turtle
      hsh = self.class.from_xml(hsh) unless hsh.is_a?(Hash)
      @hsh = hsh.deep_symbolize_keys
      load_repository # extend given vocabulary
      add_domain # @hsh[:website][:domain] a Website .
      perform
    end

    def load_repository
      voc_file = File.join Abrupt.root, 'assets', 'voc', 'wdm.ttl'
      @result = Repository.load(voc_file)
    end

    def add_domain
      domain = RDF::URI("#{WDM}Website/#{@hsh[:website][:domain]}")
      @result << Statement.new(domain, RDF.type, WDM.Website)
    end

    def self.xml(hsh)
      Gyoku.xml hsh
    end

    def self.json(hsh)
      hsh.to_json
    end

    def owl
      @result.dump @format, prefixes: PREFIXES
    end

    def self.from_xml(file)
      xml = Nokogiri::XML(File.read(file))
      hsh = Hash.from_xml(xml.to_s).deep_symbolize_keys!
      hsh[:website][:url].each_with_index do |value, state|
        TRANSFORMATIONS.each do |trafo|
          hsh[:website][:url][state] = trafo.customize_to_schema(value)
        end
      end
      hsh
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
        TRANSFORMATIONS.each do |trafo|
          t = trafo.new(state_uri, nil, value)
          t.add_individuals
          add_to_result t.result
        end
      end
    end

    def append_user_data(file)
      return unless file.is_a?(String)
      return unless File.exist?(file)
      xml = Nokogiri::XML(File.read(file))
      result = {}
      xml.css('visitor').each do |visitor|
        visitor.css('pages page').each do |page|
          transformator = Transformation::Client::Visit.new(
              @hsh[:website][:domain], page, visitor)
          transformator.add_individuals
          # add Visitor
          # add properties
          add_to_result transformator.result
        end
      end
      result
    end

    def append_rules
      rules_dir = File.join Abrupt.root, 'assets', 'rules', '*'
      Dir.glob(rules_dir).each do |rule_directory|
        Dir.glob(File.join(rule_directory, '*')).each do |rule_file|
          rule = Repository.load(rule_file)
          add_to_result(rule.statements)
        end
      end
    end
  end
end
