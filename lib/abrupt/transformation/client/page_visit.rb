# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class PageVisit < Base
        TIME_INPUT_FORMAT = '%d/%b/%Y:%H:%M:%S' # TODO: DO DRY
        TIME_OUTPUT_FORMAT = '%Y-%m-%d_%H%M%S'

        def time(time)
          Time.strptime(time, TIME_INPUT_FORMAT).strftime(TIME_OUTPUT_FORMAT)
        end

        def self.create(domain, page, visitor)
          # TODO: could them be transformatted via json schema?
          page_path = page.css('uri').text
          ip = visitor.css('ip').text
          time = visitor.css('entertime').text
          url_time = time(time)
          new(['Website', domain, 'Page', domain + page_path, 'Visitor', ip],
              ['Visit', url_time], visitor)
        end

        def add_individuals
          @values[:name] = @values.css('ip').text
          super
          add_individuals_for_view
          @result
        end

        def add_individuals_for_view
          @values.css('view').children.each do |view|
            add_individual_view(view) unless view.text?
          end
        end

        def add_individual_view(view)
          datetime = view.attributes['datetime'].value
          page_view = PageView.new(@parent_uri + @uri,
                                   [view.name.capitalize, time(datetime)],
                                   view.attributes)
          @result += page_view.add_individuals
          add_object_property(resolve_uri(@values[:name]), 'PageView',
                              page_view.resolve_uri(page_view.values[:name]))
        end
      end
    end
  end
end