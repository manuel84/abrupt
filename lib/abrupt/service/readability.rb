# @author Manuel Dudda
module Abrupt
  module Service
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Readability < Base
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'

      def service_uri
        SERVICE_URI
      end
    end
  end
end
