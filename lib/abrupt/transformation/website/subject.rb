# @author Manuel Dudda
module Abrupt
  module Transformation
    module Website
      # Readability service
      # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/subject/'
      class Subject < Base
        def add_individuals
          return @result unless @values[keyname]
          klass = class_name # Subject
          @values[keyname][:words].each do |word|
            uri = RDF::URI("#{VOC}#{klass}/#{word}")
            @result +=
                [Statement.new(uri, RDF.type, VOC[klass]),
                 Statement.new(resolve_parent_uri, VOC["has#{klass}"], uri)]
          end
          @result
        end
      end
    end
  end
end
