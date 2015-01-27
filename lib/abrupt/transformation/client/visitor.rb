# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation class for client visit data
      class Visitor < Transformation::Base
        def add_individuals
          return @result unless @values
          @values[:name] = @values[:ip]
          super
          @values.delete :name
          @values.each do |key, value|
            add_data_property(key, value) if value.is_a?(String)
          end
          @result
        end
      end
    end
  end
end
