# @author Manuel Dudda
module Abrupt
  module Transformation
    # base class
    class Base
      include RDF
      attr_accessor :parent_uri, :uri, :values, :result, :md5

      SCHEMA_MAPPING = {
          integer: :to_i,
          number: :to_f,
          string: :to_s,
          boolean: [:kind_of?, Object]
      }

      # Initializes Transformer for Individual Statement for parent_uri & uri.
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
        customize_to_schema
        @result = []
        @md5 = Digest::MD5
        add_individuals
        # transform
      end

      def customize_to_schema
        schema_file = "assets/schema/v1/#{keyname}.json"
        return unless File.exist?(schema_file)
        schema = ::JSON.load(File.read(schema_file))
        schema.deep_symbolize_keys!
        schema[:properties].each do |state_key, values|
          set_value(values, @values[state_key]) if @values[state_key]
        end
      end

      def set_value(schema_value, value)
        return unless schema_value || value
        case schema_value[:type]
        when 'object'
          schema_value[:properties].each do |k, v|
            value[k] = set_value(v, value[k])
          end
        when 'array'
          # make sure that value is an array
          [value].flatten.compact.each do |obj|
            obj.each do |k, v|
              next unless schema_value[:items][:properties][k]
              obj[k] = set_value(schema_value[:items][:properties][k], v)
            end
          end
        else
          value = value.send *SCHEMA_MAPPING[schema_value[:type].to_sym]
        end
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
        uri = resolve_uri(name)
        @result << Statement.new(uri, RDF.type, WDM[klass])
        @result << Statement.new(resolve_parent_uri, WDM["has#{klass}"], uri)
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
