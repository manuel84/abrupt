# @author Manuel Dudda
module Abrupt
  module Transformation
    # base class
    class Base
      include RDF
      attr_accessor :state, :page_uri, :result

      def initialize(state, page_uri)
        @state = state
        @page_uri = page_uri
        @result = []
        transform
      end

      def class_name
        self.class.name.split('::').last
      end

      def keyname
        class_name.downcase.to_sym
      end

      def rdf_uri(name = nil, c_name = class_name)
        delimiter = name.present? ? DELIMITER : ''
        RDF::URI("#{WDM}#{c_name}/#{@page_uri}#{delimiter}#{name}")
      end

      def add_individual(uri,
                         type = class_name,
                         parent_uri = rdf_uri(nil, 'Page'),
                         parent_type = nil)
        parent_type ||= type
        @result << Statement.new(uri, RDF.type, type)
        add_object_property(parent_uri, parent_type, uri)
      end

      def add_data_property(uri, type, value)
        @result << Statement.new(uri, WDM[type], value)
      end

      def add_object_property(parent_uri, type, child_uri)
        @result << Statement.new(parent_uri, WDM["has#{type}"], child_uri)
      end

      def transform
        return unless @state[keyname]
        @state[keyname].each do |k, v|
          s = k.to_s.eql?('language') ? "#{keyname}Language" : k
          add_data_property(rdf_uri(nil, 'Page'), s, v)
        end
      end
    end
  end
end
