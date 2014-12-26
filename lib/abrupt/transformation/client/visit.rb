# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class Visit < Base
        def initialize(domain, page, visitor)
          input_format = '%d/%b/%Y:%H:%M:%S'
          output_format = '%Y-%m-%d_%H%M%S'
          url_time = Time.strptime(visitor.css('entertime').text, input_format)
                         .strftime(output_format)
          super(['Website', domain, 'Page', domain + page.css('uri').text],
                ['Visit', visitor.css('ip').text, 'Time', url_time])
        end
      end
    end
  end
end
