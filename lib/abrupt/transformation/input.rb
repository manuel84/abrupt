# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Input < Base
      attr_accessor :form_uri

      def add_individuals
        return unless @values[keyname]
        form_id = md5.hexdigest(@values[keyname].to_s)
        @uri = ['Form', form_id]
        add_individual
        @parent_uri += @uri
        @values[keyname].each do |input_type, inputs|
          [inputs].to_a.flatten.each do |input|
            form_element_id = input[:id] || md5.hexdigest(input.to_s)
            @uri = [input_type.to_s.camelcase, form_element_id]
            add_individual
            input.each { |type, value| add_data_property type, CGI.escapeHTML(value) if type && value }
          end
        end
      end
    end
  end
end
