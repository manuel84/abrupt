# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Link < Base
      def uri_id

      end

      def add_individuals
        @values[keyname][:a].each do |link|
          add_individual link[:href]
          link.each do |type, value|
            add_data_property type, CGI.escapeHTML(value), link[:href]
          end
        end
      end
    end
  end
end
