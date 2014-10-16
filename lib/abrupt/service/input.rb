# @author Manuel Dudda
require 'rest_client'
module Abrupt
  module Service
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Input < Base
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/input/'
    end
  end
end
