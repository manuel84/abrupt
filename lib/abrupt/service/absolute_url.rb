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

      def execute
        options = {
            method: :post,
            timeout: 6000,
            open_timeout: 6000,
            accept: :html
        }
        options.merge!(url: @url, payload: @html)
        begin
          RestClient::Request.execute(options).to_str
        rescue => e
          puts "some problems with #{@url}"
          puts e
          nil
        end
      end
    end
  end
end
