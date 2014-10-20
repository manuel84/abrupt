# @author Manuel Dudda
module Abrupt
  module Service
    # Complexity service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'
    class Complexity < Base
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'

      def self.available_options
        %w(adblock vicram vizweb color contrast ratio)
      end

      def service_uri
        SERVICE_URI
      end
    end
  end
end
