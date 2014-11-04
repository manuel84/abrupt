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
      end

      def class_name
        self.class.name.split('::').last
      end

      def keyname
        class_name.downcase.to_sym
      end

      def rdf_uri(name)
        RDF::URI("#{WDM}#{class_name}/#{name}")
      end

      def add_individual(uri, type = class_name, add_to_page = true)
        @result << Statement.new(uri, RDF.type, type)
        add_object_property(@page_uri, class_name, uri)
      end

      def add_data_property(uri, type, value)
        @result << Statement.new(uri, WDM[type], value)
      end

      def add_object_property(parent_uri, type, child_uri)
        @result << Statement.new(parent_uri, WDM["has#{type}"], child_uri)
      end


      def transform
        if @state[keyname]
          @state[keyname].each do |k, v|
            s = k.to_s.eql?('language') ? "#{keyname}Language" : k
            add_data_property(@page_uri, s, v)
          end
        end
        @result
      end
    end
  end
end
