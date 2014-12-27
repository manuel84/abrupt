# @author Manuel Dudda
module Abrupt
  module Transformation
    module Website
      # Input service
      # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/input/'
      # schema located in {PROJECT_ROOT}/assets/schema/v1/input.json
      class Input < Base
        attr_accessor :form_uri

        def add_individuals
          return unless @values[keyname]
          form_id = md5.hexdigest(@values[keyname].to_s)
          @uri = ['Form', form_id]
          add_individual
          @parent_uri += @uri
          @values[keyname].each do |input_type, inputs|
            [inputs].flatten.compact.each do |input|
              form_element_id = input[:id] || md5.hexdigest(input.to_s)
              @uri = [input_type.to_s.camelcase, form_element_id]
              add_individual
              add_data_properties input
            end
          end
        end

        def add_data_properties(input)
          input.each do |type, value|
            next unless type && value
            v = value.is_a?(String) ? CGI.escapeHTML(value) : value
            add_data_property type, v
          end
        end
      end
    end
  end
end
