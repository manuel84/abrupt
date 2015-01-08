# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class PageView < Transformation::Base
        def add_individuals
          datetime = @values['datetime']
          return @result unless datetime
          @values[:name] = ::Abrupt.format_time(datetime)
          super
          @values.each do |_i, attr|
            next if attr.is_a?(String)
            name = attr.name.eql?('name') ? 'inputname' : attr.name
            value = if attr.name.eql?('datetime')
                      Abrupt.parse_time(attr.value)
                    else
                      attr.value
                    end
            add_data_property(name, value)
          end
          @result
        end
      end
    end
  end
end
