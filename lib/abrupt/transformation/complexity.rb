# @author Manuel Dudda
module Abrupt
  module Transformation
    # Complexity service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'
    class Complexity < Base
      def add_individuals
        @uri = @parent_uri.slice!(-2, 2)
        super
      end
    end
  end
end
