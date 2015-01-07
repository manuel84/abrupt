require_relative 'page_visit'
# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class PageView < PageVisit
        def add_individuals
          # @result << Statement.new(uri, RDF.type, WDM[klass])
          # add_object_property(parent_uri, type, child_uri)
          # add_data_property(type, value, name = @values[:name])
          @values.each do |_i, attr|
            # pp attr.name
            # pp attr.value
          end
          @result
        end
      end
    end
  end
end
