# @author Manuel Dudda
require 'rest_client'
require 'gyoku'
require 'rdf'
require 'linkeddata'
require 'active_support/core_ext/hash'
%w( base
    readability
    subject
    input
    complexity
    picture
    link).each do |f|
  require "abrupt/transformation/#{f}"
end
# Abrupt Converter
module Abrupt
  # Converter
  class Converter
    include RDF
    # rubocop:disable all
    TRANSFORMATIONS =
        [
            Transformation::Readability,
            Transformation::Input,
            # Abrupt::Transformation::Subject,
            # Abrupt::Transformation::Complexity,
            Transformation::Link,
            Transformation::Picture
        ]
    SCHEMA_MAPPING = {
        integer: :to_i,
        number: :to_f,
        string: :to_s
    }
    # rubocop:enable all

    attr_accessor :hsh, :values, :result

    def initialize(hsh)
      @hsh = hsh.deep_symbolize_keys
      # extend given vocabulary
      @result = Repository.load('assets/owl/wdm_vocabulary.owl')
      domain = RDF::URI("#{WDM}Website/#{hsh[:website][:domain]}")
      @result << Statement.new(domain, RDF.type, WDM.Website)
      perform
    end

    def self.transform_hash(hsh)
      uri = Addressable::URI.parse(hsh.keys.first).normalize
      result = {
          website: {
              domain: "#{uri.scheme}://#{uri.host}",
              url: []
          }
      }
      hsh.each_with_index do |(key, value), _index|
        page = {
            name: key,
            state: value
        }
        result[:website][:url] << page
      end
      result
    end

    def self.xml(hsh)
      Gyoku.xml hsh
    end

    def self.json(hsh)
      hsh.to_json
    end

    def self.to_repository(hsh)
      hsh.deep_symbolize_keys!
      # extend given vocabulary
      result = Repository.load('assets/owl/wdm_vocabulary.owl')
      domain = RDF::URI("#{WDM}Website/#{hsh[:website][:domain]}")
      result << Statement.new(domain, RDF.type, WDM.Website)
      Converter.perform(hsh[:website][:url], result, hsh[:website][:domain])
      result
    end

    def owl
      @result.dump :rdfxml
    end

    def self.from_xml(file)
      xml = Nokogiri::XML(File.read(file))
      result = Hash.from_xml(xml.to_s).deep_symbolize_keys!
      Converter.customize(result)
    end

    # rubocop:disable all
    def self.customize(hsh)
      schema = ::JSON.load(File.read('assets/schema/readability.json'))
      schema.deep_symbolize_keys!
      schema[:properties].each do |state_key, values|
        values[:properties].each do |key, value|
          hsh[:website][:url].each do |url|
            url[:state][state_key][key] = url[:state][state_key][key].send SCHEMA_MAPPING[value[:type].to_sym]
          end
        end
      end
      hsh
    end

    # rubocop:enable all

    def add_to_result(statements)
      statements.each do |stmt|
        @result << stmt
      end
    end

    def perform
      @hsh[:website][:url].each do |url|
        page_name = url[:name].gsub(/([^\/])$/, '\1/') # append /
        website = ['Website', @hsh[:website][:domain]]
        page = ['Page', page_name]
        add_to_result Transformation::Base.new(website, page).result
        next unless url[:state]
        perform_states url[:state], website + page
      end
    end

    def perform_states(states, parent_uri)
      states = states.is_a?(Array) ? states : [states]
      states.each do |value|
        state = ['State', value[:name]]
        state_uri = parent_uri + state
        add_to_result Transformation::Base.new(parent_uri, state).result
        TRANSFORMATIONS.each do |trafo|
          add_to_result trafo.new(state_uri, nil, value).result
        end
      end
    end
  end
end
