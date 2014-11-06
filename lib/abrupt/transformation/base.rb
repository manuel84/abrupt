# @author Manuel Dudda
module Abrupt
  module Transformation
    # base class
    class Base
      include RDF
      attr_accessor :parent_uri, :uri, :values, :result, :md5

      # Initializes Transformator for Individual Statement for parent_uri & uri.
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
        @parent_uri = parent_uri.to_a.map { |u| u.gsub(/([\/]*)$/, '') }
        @uri = uri.to_a.map { |u| u.gsub(/([\/]*)$/, '') }
        @values = values
        @result = []
        @md5 = Digest::MD5
        add_individuals
        # transform
      end

      def add_individuals
        add_individual
        return unless @values[keyname]
        @values[keyname].each do |k, v|
          s = k.to_s.eql?('language') ? "#{keyname}Language" : k
          add_data_property s, v
        end
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
        "#{WDM}#{@parent_uri.join('/')}"
      end

      def resolve_parent_uri
        RDF::URI(resolve_parent_uri_part)
      end

      def resolve_uri_part(name)
        if @uri.empty?
          "#{class_name}/#{name}"
        else
          "#{@uri.join('/')}"
        end
      end

      def resolve_uri(name)
        RDF::URI(resolve_parent_uri_part + '/' + resolve_uri_part(name))
      end

      def add_individual(name = @values[:name], klass = nil)
        klass ||= @uri.empty? ? class_name : @uri.first
        @result << Statement.new(resolve_uri(name), RDF.type, WDM[klass])
        @result << Statement.new(resolve_parent_uri, WDM["has#{klass}"], resolve_uri(name))
      end

      def add_data_property(type, value, name = @values[:name])
        @result << Statement.new(resolve_uri(name), WDM[type], value)
      end

      def add_object_property(parent_uri, type, child_uri)
        @result << Statement.new(parent_uri, WDM["has#{type}"], child_uri)
      end
    end
  end
end
