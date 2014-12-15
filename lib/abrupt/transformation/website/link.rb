# @author Manuel Dudda
module Abrupt
  module Transformation
    module Website
      # Readability service
      # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
      class Link < Base
        def add_individuals
          return unless @values[keyname] && @values[keyname][:a]
          @values[keyname][:a].each do |link|
            add_individual link[:href]
            link.each do |type, value|
              next unless type && value
              v = value.is_a?(String) ? CGI.escapeHTML(value) : value
              add_data_property type, v, link[:href]
            end
          end
        end
      end
    end
  end
end
