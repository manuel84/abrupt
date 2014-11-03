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
        result = if @state[self.class.keyname]
                   @state[self.class.keyname].map do |k, v|
                     Statement.new(@page_uri, Abrupt::Converter::WDM[k], v)
                   end
                 else
                   []
                 end
        result
      end
    end
  end
end
