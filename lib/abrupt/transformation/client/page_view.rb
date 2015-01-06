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
          @values.children.each do |action|
            unless action.text?
              pp action.name
              pp action.attributes.values.map { |v| [v.name, v.value] }
            end
          end
          @result
        end
      end
    end
  end
end
