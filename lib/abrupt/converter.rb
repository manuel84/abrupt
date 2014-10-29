# @author Manuel Dudda
require 'rest_client'
require 'gyoku'
module Abrupt
  # Converter
  class Converter
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

    end
  end
end
