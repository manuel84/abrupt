# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation class for client visit data
      class Visitor < Transformation::Base
        def add_individuals
          return @result unless @values
          @values[:name] = @values.css('ip').text
          super
          @values.children.each do |prop|
            add_data_property(prop.name, prop.text) if prop.children.count == 1
          end
          @result
        end
      end
    end
  end
end
