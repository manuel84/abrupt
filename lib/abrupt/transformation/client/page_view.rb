require_relative 'page_visit'
# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class PageView < PageVisit
        def add_individuals
          datetime = @values['datetime']
          return @result unless datetime
          @values[:name] = ::Abrupt.format_time(datetime)
          add_individual
          @values.each do |_i, attr|
            add_data_property(attr.name, attr.value) unless attr.is_a?(String)
          end
          @result
        end
      end
    end
  end
end
