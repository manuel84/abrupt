# @author Manuel Dudda
require 'rest_client'
module Abrupt
  module Service
    # Complexity service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'
    class Complexity < Base
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'
    end
  end
end
