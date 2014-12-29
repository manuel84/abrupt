# @author Manuel Dudda
module Abrupt
  module Transformation
    module Website
      # Readability service
      # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
      class Picture < Base
        def add_individuals
          return unless @values[keyname] && @values[keyname][:images]
          @values[keyname][:images].each do |img|
            add_individual img[:filename]
            img.each do |type, value|
              value = CGI.escapeHTML(value) if value.is_a? String
              add_data_property type, value, img[:filename]
            end
          end
        end
      end
    end
  end
end