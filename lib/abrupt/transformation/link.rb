# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Link < Base
      def transform
        result = []
        if @state[:link]
          result += transform_anchors(@state[:link][:a])
        end
        result
      end

      def transform_anchors(anchors)
        result = []
        anchors.each do |link|
          link_uri = uri(link[:href])
          # Individual
          result << Statement.new(link_uri, RDF.type, WDM['Link'])
          # Data Properties
          result += link.map { |k, v| Statement.new(link_uri, WDM[k], CGI.escapeHTML(v)) }
          # Object Properties
          result << Statement.new(@page_uri, WDM['hasLink'], link_uri)
        end
        result
      end
    end
  end
end
