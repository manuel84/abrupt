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
            Abrupt::Transformation::Readability,
            #Abrupt::Transformation::Input,
            # Abrupt::Transformation::Subject,
            # Abrupt::Transformation::Complexity,
            Abrupt::Transformation::Link,
        # Abrupt::Transformation::Picture
        ]
    # rubocop:enable all
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

    def self.owl(hsh)
      Converter.to_repository(hsh).dump :rdfxml
    end

    def self.from_xml(file)
      xml = Nokogiri::XML(File.read(file))
      result = Hash.from_xml(xml.to_s).deep_symbolize_keys!
      Converter.customize(result)
    end

    # rubocop:disable all
    def self.customize(hsh)
      hsh[:website][:url].each do |url|
        url[:state][:readability][:readability] = url[:state][:readability][:readability].to_f
        url[:state][:readability][:syllables] = url[:state][:readability][:syllables].to_i
        url[:state][:readability][:words] = url[:state][:readability][:words].to_i
        url[:state][:readability][:numberOfLinks] = url[:state][:readability][:numberOfLinks].to_i
        url[:state][:readability][:bigwords] = url[:state][:readability][:bigwords].to_i
        url[:state][:readability][:sentences] = url[:state][:readability][:sentences].to_i
      end
      hsh
    end

    # rubocop:enable all

    def self.add_to_repository(repository, statements)
      statements.each do |stmt|
        repository << stmt
      end
    end

    def self.perform(hsh, result, domain)
      # TODO: extract domain as class var
      hsh.each do |url|
        page_name = url[:name].gsub(/([^\/])$/, '\1/') # append /
        website = ['Website', domain]
        page = ['Page', page_name]
        self::add_to_repository result, Abrupt::Transformation::Base.new(website, page).result
        next unless url[:state]
        states = url[:state].is_a?(Array) ? url[:state] : [url[:state]]
        states.each do |value|
          state = ['State', value[:name]]
          self::add_to_repository result, Abrupt::Transformation::Base.new(website + page, state).result
          TRANSFORMATIONS.each do |transformation_class|
            self::add_to_repository result, transformation_class.new(website + page + state, nil, value).result
          end
        end
      end
    end
  end
end
