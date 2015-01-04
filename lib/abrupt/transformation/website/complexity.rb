# @author Manuel Dudda
module Abrupt
  module Transformation
    module Website
      # Complexity service
      # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'
      class Complexity < Transformation::Base
        def add_individuals
          @uri = @parent_uri.slice!(-2, 2)
          return @result unless @values[keyname]
          # flatten vicram complexity
          @values[keyname][:vicramComplexity] =
              @values[keyname][:vicram].delete(:complexity)
          @values[keyname].delete :vicram
          super
        end
      end
    end
  end
end
