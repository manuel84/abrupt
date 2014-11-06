# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Input < Base
      attr_accessor :form_uri

      def transform
        return unless @state[keyname]
        form_uri = RDF::URI("#{@page_uri}-form-#{@state[keyname].__id__}")
        add_individual(form_uri, 'Form')
        @state[keyname].each do |input_type, inputs|
          [inputs].to_a.flatten.each do |input|
            id = input[:id] || input.__id__
            input_uri = RDF::URI("#{@page_uri}-form_element-#{id}")
            type = input_type.to_s.camelcase
            # input_uri type Input
            # form_uri hasFormElement input_uri
            add_individual(input_uri, type, form_uri, 'FormElement')
            input.select { |key, v| key && v }.each do |data_type, value|
              add_data_property(input_uri, data_type, value)
            end
          end
        end
      end
    end
  end
end
