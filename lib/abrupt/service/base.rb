# @author Manuel Dudda
require 'rest_client'
module Abrupt
  module Service
    # base class
    class Base
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'

      def initialize(html)
        @html = html
      end
      # TODO: naming of interface execute
      def execute
        ::RestClient.post(SERVICE_URI, @html).to_str
      end
    end
  end
end
