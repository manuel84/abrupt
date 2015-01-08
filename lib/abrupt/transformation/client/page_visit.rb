# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class PageVisit < Base
        def self.create(domain, page, visitor)
          # TODO: could them be transformatted via json schema?
          page_path = page.css('uri').text
          ip = visitor.css('ip').text
          time = visitor.css('entertime').text
          url_time = ::Abrupt.format_time(time)
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
            add_page_view(view) unless view.text?
          end
        end

        def add_page_view(view)
          time = ::Abrupt.format_time(view.attributes['datetime'].value)
          page_view = PageView.new(@parent_uri + @uri,
                                   [view.name.capitalize, time],
                                   view.attributes)
          @result += page_view.add_individuals
          add_object_property(resolve_uri, 'PageView', page_view.resolve_uri)
        end
      end
    end
  end
end
