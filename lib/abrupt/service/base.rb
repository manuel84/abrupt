# @author Manuel Dudda
require 'rest_client'
module Abrupt
  module Service
    # base class
    class Base
      attr_accessor :url, :abbr, :options
      # TODO: outsource service uri to module Service
      SERVICE_URI = 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'

      def service_uri
        SERVICE_URI
      end

      def initialize(html, options = {})
        @html = html
        @options = options
        query_params = if @options.count > 0
                         options_arr = @options.map { |k, v| "#{k}=#{v}" }
                         '?' + options_arr.reduce { |a, e| "#{a}&#{e}" }
                       else
                         ''
                       end
        @url = service_uri + query_params
        @abbr = self.class.name[0].downcase
        @options = []
      end

      # TODO: naming of interface execute
      def execute
        options = {method: :post, timeout: 6000, open_timeout: 6000}
        RestClient::Request.execute(options.merge(url: @url, payload: @html)).to_str
      end
    end
  end
end
