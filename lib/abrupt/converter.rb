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
    TRANSFORMATIONS =
        [
          Abrupt::Transformation::Readability,
          Abrupt::Transformation::Input,
          Abrupt::Transformation::Subject,
          Abrupt::Transformation::Complexity,
          Abrupt::Transformation::Link,
          Abrupt::Transformation::Picture
        ]

    include RDF
    WDM = RDF::Vocabulary.new('http://wba.cs.hs-rm.de/wdm-service/wdmOWL#')

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
      domain = RDF::URI(hsh[:website][:domain])
      result << Statement.new(domain, RDF.type, WDM.Website)
      Converter.perform(hsh[:website][:url], result, domain)
      result
    end

    def self.owl(hsh)
      self.class.to_repository(hsh).dump :rdfxml
    end

    def self.from_xml(file)
      xml = Nokogiri::XML(File.read(file))
      result = Hash.from_xml(xml.to_s)
      result.deep_symbolize_keys!
    end

    def self.perform(hsh, result, domain)
      # TODO: extract domain as class var
      hsh.each do |url|
        page_uri = RDF::URI(url[:name])
        result << Statement.new(page_uri, RDF.type, WDM.Page)
        if url[:state]
          state = url[:state]
          TRANSFORMATIONS.each do |transformation_class|
            new_statements = transformation_class.new(state, page_uri).transform
            new_statements.each { |stmt| result << stmt }
          end
        end
        result << Statement.new(domain, WDM.hasPage, page_uri)
      end
    end
  end
end
