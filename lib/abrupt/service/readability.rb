# @author Manuel Dudda
module Abrupt
  module Service
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Readability < Base
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'

      def self.available_options
        ['lang']
      end

      def service_uri
        SERVICE_URI
      end

      def execute
        super
        superfluous_keys = %w(originalText hyphenText)
        @response.delete_if { |key, _value| superfluous_keys.include?(key) }
        @response
      end
    end
  end
end
