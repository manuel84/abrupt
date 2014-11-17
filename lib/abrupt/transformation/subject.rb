# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/subject/'
    class Subject < Base
      def add_individuals
        return unless @values[keyname]
        klass = class_name # Subject
        @values[keyname][:words].each do |word|
          uri = RDF::URI("#{WDM}#{klass}/#{word}")
          @result << Statement.new(uri, RDF.type, WDM[klass])
          @result << Statement.new(resolve_parent_uri, WDM["has#{klass}"], uri)
        end
      end
    end
  end
end
