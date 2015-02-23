# @author Manuel Dudda
module Abrupt
  module Transformation
    module Client
      # Transformation class for client visit data
      class Visit < Base
        def add_individuals
          @values[:name] = @uri.last
          super
          @values.delete :name
          add_visit_duration
          @values.each do |key, value|
            add_property(key, value) if value
          end
          add_individuals_for_view
          @result
        end

        def add_property(key, value)
          enumerable = value.is_a?(Hash) || value.is_a?(Array)
          return if enumerable # value.is_a?(Enumerable)
          name = case key
                 when :uri
                   uri = [@parent_uri[1], value].map(&:remove_last_slashes)
                   parent_uri_path = (@parent_uri[0..-3] + ['Page', uri.join])
                   parent_uri = "#{VOC}#{parent_uri_path.join('/')}"
                   # Page hasPageVisit visit
                   add_object_property(parent_uri, 'PageVisit', resolve_uri)
                   key
                 when :size # TODO: transform via customize_to_schema
                   'contentlength'
                 else
                   key
                 end
          add_data_property(name, CGI.escape(value))
        end

        def add_individuals_for_view
          page_views = @values[:view]
          return unless page_views
          page_views.each do |type, view|
            [view].flatten.each do |attributes|
              add_page_view(type.to_s.capitalize, attributes)
            end
          end
        end

        def add_page_view(type, attributes)
          time = ::Abrupt.format_time(attributes[:datetime])
          page_view = PageView.new(@parent_uri + @uri,
                                   [type, time],
                                   attributes)
          @result += page_view.add_individuals
        end

        def add_visit_duration
          leavetime = Abrupt.parse_time(@values[:leavetime])
          enterteime = Abrupt.parse_time(@values[:entertime])
          return if leavetime && enterteime # maybe no recognized leavetime
          visit_duration = (leavetime - enterteime).to_f # in seconds
          add_data_property('visitDuration', visit_duration)
        end
      end
    end
  end
end
