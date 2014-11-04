# @author Manuel Dudda
module Abrupt
  module Transformation
    # base class
    class Base
      include RDF
      attr_accessor :state, :page_uri

      def initialize(state, page_uri)
        @state = state
        @page_uri = page_uri
      end

      def self.keyname
        name.split('::').last.downcase.to_sym
      end

      def transform
        keyname = self.class.keyname
        result = []
        if @state[keyname]
          result += @state[keyname].map do |k, v|
            s = k.to_s.eql?('language') ? "#{keyname}Language" : k
            Statement.new(@page_uri, WDM[s], v)
          end
        end
        result
      end
    end
  end
end
