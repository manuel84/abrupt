# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Readability < Base
      def add_individuals
        @uri = @parent_uri.slice!(-2, 2)
        super
      end
    end
  end
end
