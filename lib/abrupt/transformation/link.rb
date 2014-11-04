# @author Manuel Dudda
module Abrupt
  module Transformation
    # Readability service
    # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/readability/'
    class Link < Base
      def transform
        result = []
        if @state[:link]
          @state[:link].each do |link|
            link_uri = RDF::URI(link[:href])
            result += link.map do |k, v|
              Statement.new(link_uri, WDM[k], v)
            end
            has_link = WDM['hasLink']
            result << Statement.new(@page_uri, has_link, link_uri)
          end
        end
        result
      end
    end
  end
end
