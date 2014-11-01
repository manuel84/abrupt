# @author Manuel Dudda
require 'rest_client'
require 'gyoku'
require 'rdf'
require 'linkeddata'
require 'active_support/core_ext/hash'
module Abrupt
  # Converter
  class Converter
    include RDF
    WDM = RDF::Vocabulary.new('http://wba.cs.hs-rm.de/wdm-service/wdmOWL#')

    def self.transform_hash(input)
      uri = Addressable::URI.parse(input.keys.first).normalize
      result = {
          website: {
              domain: "#{uri.scheme}://#{uri.host}",
              url: []
          }
      }
      input.each_with_index do |(key, value), _index|
        page = {
            name: key,
            state: value
        }
        result[:website][:url] << page
      end
      result
    end

    def self.xml(input)
      Gyoku.xml input
    end

    def self.json(input)
      input.to_json
    end

    def self.owl(input)
      input = input.with_indifferent_access
      result = Repository.load('assets/owl/wdm_vocabulary.owl') # extend given vocabulary
      domain = RDF::URI(input[:website][:domain])
      result << Statement.new(domain, RDF.type, WDM.Website)
      input[:website][:url].each do |url|
        page_uri = RDF::URI(url[:name])
        result << Statement.new(page_uri, RDF.type, WDM.Page)
        if url[:state]
          if url[:state][:readability]
            url[:state][:readability].each do |key, value| # readability => { :sentences => 32}
              result << Statement.new(page_uri, WDM[key], value)
            end
          end
        end
        result << Statement.new(domain, WDM.hasPage, page_uri)
      end

      puts result.dump :rdfxml
      result
    end

  end
end
