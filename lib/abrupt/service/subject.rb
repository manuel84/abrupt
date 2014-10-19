# @author Manuel Dudda
module Abrupt
  module Service
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Subject < Base
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/subject/'

      def service_uri
        SERVICE_URI
      end
    end
  end
end
