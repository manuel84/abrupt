# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Input < Base
      attr_accessor :form_uri

      def transform
        keyname = self.class.keyname
        result = []
        if @state[keyname]
          @form_uri = RDF::URI("#{@page_uri}-form-#{@state[keyname].__id__}")
          result << Statement.new(form_uri, RDF.type, WDM['Form'])
          result << Statement.new(@page_uri, WDM['hasForm'], @form_uri)
          result += transform_inputs(@state[keyname])
        end
        result
      end

      def transform_inputs(inputs_hsh)
        result = []
        inputs_hsh.each do |input_type, inputs|
          type = input_type.to_s.camelcase
          result += transform_input_elements(inputs, type)
        end
        result
      end

      def transform_input_elements(inputs_arr, type)
        result = []
        [inputs_arr].to_a.flatten.each do |input|
          id = input[:id] || input.__id__
          input_uri = RDF::URI("#{@page_uri}-form_element-#{id}")
          result << Statement.new(input_uri, RDF.type, WDM[type])
          input.select! { |key, value| key && value }
          input.each { |k, v| result << Statement.new(input_uri, WDM[k], v) }
          result << Statement.new(@form_uri, WDM["has#{type}"], input_uri)
        end
        result
      end
    end
  end
end
