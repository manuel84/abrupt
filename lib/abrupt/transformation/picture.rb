# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Picture < Base
      def add_individuals
        return unless @values[keyname][:images]
        @values[keyname][:images].each do |img|
          add_individual img[:filename]
          img.each do |type, value|
            add_data_property type, CGI.escapeHTML(value), img[:filename]
          end
        end
      end
    end
  end
end
