# @author Manuel Dudda
module Abrupt
  module Transformation
    module Website
      # Complexity service
      # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'
      class Complexity < Base
        def add_individuals
          @uri = @parent_uri.slice!(-2, 2)
          return @result unless @values[keyname]
          # flatten vicram complexity
          @values[keyname][:vicramComplexity] =
              @values[keyname][:vicram].delete(:complexity)
          add_contrast_properties
          @values[keyname].delete :vicram
          super
        end

        def add_contrast_properties
          contrast = @values[keyname][:contrast]
          return unless contrast && contrast[:_1]
          contrast[:_1].each do |type, value|
            add_data_property(type, value)
          end
          @values[keyname].delete :contrast
        end
      end
    end
  end
end
