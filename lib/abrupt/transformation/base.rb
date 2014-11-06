# @author Manuel Dudda
module Abrupt
  module Transformation
    # base class
    class Base
      include RDF
      attr_accessor :parent_uri, :uri, :values, :result, :md5


      # Initializes Transformator for Individual Statement for parent_uri and uri.
      # @param parent_uri [Array] the parent uri in array structure of paths
      # @param uri [Array] the uri as array structure of path and id
      # @example
      # Readability.new([
      #     'Website',
      #     'http://www.rikscha-mainz.de',
      #     'Page',
      #     'http://www.rikscha-mainz.de/Angebote'
      #   ], [
      #     'State',
      #     'state54'
      #   ])
      def initialize(parent_uri, uri, values = {})
        @parent_uri = parent_uri.freeze
        @uri = uri.freeze
        @values = values
        @result = []
        @md5 = Digest::MD5
        add_individual
        transform
      end

      # Returns the class name
      def class_name
        self.class.name.split('::').last
      end

      # Returns the keyname
      # @example:
      # Readability.new(parent_uri, uri).keyname
      #   => :readability
      def keyname
        class_name.downcase.to_sym
      end

      def resolve_parent_uri_part
        "#{WDM}#{@parent_uri.join('/')}".gsub(/([\/]*)$/, '')
      end

      def resolve_parent_uri
        RDF::URI(resolve_parent_uri_part)
      end

      def resolve_uri_part
        "#{@uri.join('/')}".gsub(/([\/]*)$/, '')
      end

      def resolve_uri
        RDF::URI(resolve_parent_uri_part + '/' + resolve_uri_part)
      end

      def add_individual
        @result << Statement.new(resolve_uri, RDF.type, WDM[@uri.first])
        @result << Statement.new(resolve_parent_uri, WDM["has#{@uri.first}"], resolve_uri)
      end

      def x2(uri,
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
        return unless @values[keyname]
        @values[keyname].each do |k, v|
          s = k.to_s.eql?('language') ? "#{keyname}Language" : k
          # add_data_property(resolve_uri, s, v)
        end
      end
    end
  end
end
