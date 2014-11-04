# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Link < Base
      def transform
        transform_anchors(@state[:link][:a]) if @state[:link]
        @result
      end

      def transform_anchors(anchors)
        anchors.each do |link|
          link_uri = rdf_uri(link[:href])
          add_individual link_uri
          link.each do |type, value|
            add_data_property(link_uri, type, CGI.escapeHTML(value))
          end
        end
      end
    end
  end
end
