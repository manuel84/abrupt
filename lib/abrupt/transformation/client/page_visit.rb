# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class PageVisit < Base
        def self.create(domain, page, visitor)
          # TODO: could them be transformatted via json schema?
          input_format = '%d/%b/%Y:%H:%M:%S'
          output_format = '%Y-%m-%d_%H%M%S'
          time = visitor.css('entertime').text
          url_time = Time.strptime(time, input_format).strftime(output_format)
          new(['Website', domain, 'Page', domain + page.css('uri').text],
              ['Visit', visitor.css('ip').text, 'Time', url_time], visitor)
        end

        def add_individuals
          super
          @values.css('view').each do |view|
            @result += PageView.new(@parent_uri, @uri, view).add_individuals
          end
          @result
        end
      end
    end
  end
end
