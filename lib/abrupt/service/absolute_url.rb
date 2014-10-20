# @author Manuel Dudda
module Abrupt
  module Service
    # Complexity service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/absoluteurl/'
    class AbsoluteUrl < Base
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/absoluteurl/'

      def service_uri
        SERVICE_URI
      end
    end
  end
end
