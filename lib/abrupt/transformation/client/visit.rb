# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation clas for client visit data
      class Visit < Base
        def add_individuals
          @values[:name] = @uri.last
          super
          @values.children.each do |prop|
            add_property(prop) if prop.children.count == 1
          end
          add_individuals_for_view
          @result
        end

        def add_property(prop)
          case prop.name
          when 'uri'
            uri = [@parent_uri[1], prop.text].map(&:remove_last_slashes)
            parent_uri_path = (@parent_uri[0..-3] + ['Page', uri.join])
            parent_uri = "#{VOC}#{parent_uri_path.join('/')}"
            # Page hasVisit visit
            add_object_property(parent_uri, 'Visit', resolve_uri)
          when 'size' # TODO: transform via customize_to_schema
            prop.name = 'contentlength'
          end
          add_data_property(prop.name, prop.text)
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
        end
      end
    end
  end
end
