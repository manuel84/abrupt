# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Input < Base
      attr_accessor :form_uri

      def transform
        if @state[keyname]
          form_uri = RDF::URI("#{@page_uri}-form-#{@state[keyname].__id__}")
          add_individual(form_uri, 'Form')
          @state[keyname].each do |input_type, inputs|
            [inputs].to_a.flatten.each do |input|
              id = input[:id] || input.__id__
              input_uri = RDF::URI("#{@page_uri}-form_element-#{id}")
              # input_uri type Input
              # form_uri hasFormElement input_uri
              add_individual(input_uri, input_type.to_s.camelcase, form_uri, 'FormElement')
              input.select { |key, v| key && v }.each do |type, value|
                add_data_property(input_uri, type, value)
              end
            end
          end
        end
        @result
      end
    end
  end
end
