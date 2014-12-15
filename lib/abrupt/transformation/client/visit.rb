# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class Visit < Base
        def initialize(domain, page, visitor)
          time_format = '%d/%b/%Y:%H:%M:%S'
          time_output_format = '%Y-%m-%d_%H%M%S'
          url_time = Time.strptime(visitor.css('entertime').text, time_format)
                         .strftime(time_output_format)
          super(['Website', domain, 'Page', domain + page.css('uri').text],
                ['Visit', visitor.css('ip').text, 'Time', url_time])
        end
      end
    end
  end
end
