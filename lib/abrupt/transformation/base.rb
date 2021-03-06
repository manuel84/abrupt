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
        @parent_uri = parent_uri.to_a.map(&:remove_last_slashes)
        @uri = uri.to_a.map(&:remove_last_slashes)
        @values = values
        @result = []
      end

      # rubocop:disable all
      def self.customize_to_schema(values)
        @values = values
        keyname = name.split('::').last.downcase.to_sym
        schema_file = File.join Abrupt.root, 'assets', 'schema', 'v1', "#{keyname}.json"
        return values unless File.exist?(schema_file)
        schema = ::JSON.load(File.read(schema_file)).deep_symbolize_keys
        # :button => ..., :text => {:type => "array", :items => {...}}
        schema[:properties][keyname][:properties].each do |state_key, state_schema|
          set_value(state_key, state_schema, [':state', ":#{keyname}"])
        end
        @values
      end

      def self.set_value(key, schema, ref)
        ref << ":#{key}"
        key_string = '[' + ref.join('][') + ']'
        value = eval "@values#{key_string}" rescue nil
        return unless value
        case schema[:type]
        when 'array'
          case schema[:items][:type]
          when 'object'
            # :name => { :type => :string }
            schema[:items][:properties].each do |arr_key, arr_val|
              eval "@values#{key_string} = [value].flatten.compact" unless value.is_a? Array
              value.each_with_index do |_obj, i|
                set_value arr_key, arr_val, ref.dup + [i]
              end
            end
          end
        when 'object'
          schema[:properties].each do |schema_key, schema_value|
            set_value(schema_key, schema_value, ref.dup)
          end
        else
          if value.is_a? Array
            value.each_with_index do |val, i|
              eval "@values#{key_string}[i] = val.send(*SCHEMA_MAPPING[schema[:type].to_sym])"
            end
          else
            eval "@values#{key_string} = value.send(*SCHEMA_MAPPING[schema[:type].to_sym])"
          end
        end
      end

      # rubocop:enable all

      def add_individuals
        add_individual
        return @result unless @values[keyname]
        @values[keyname].each do |k, v|
          s = k.to_s.eql?('language') ? "#{keyname}Language" : k
          add_data_property s, v
        end
        @result
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
        "#{VOC}#{@parent_uri.join('/')}"
      end

      def resolve_parent_uri
        RDF::URI(resolve_parent_uri_part)
      end

      def resolve_uri_part(name)
        @uri.empty? ? "#{class_name}/#{name}" : "#{@uri.join('/')}"
      end

      def resolve_uri(name = nil)
        name ||= @uri.last
        RDF::URI(resolve_parent_uri_part + '/' + resolve_uri_part(name))
      end

      def add_individual(name = @values[:name], klass = nil)
        klass ||= (@uri.empty? ? class_name : @uri.first).to_s.camelize
        uri = resolve_uri(name)
        @result << Statement.new(uri, RDF.type, VOC[klass])
        @result << Statement.new(resolve_parent_uri, VOC["has#{klass}"], uri)
      end

      def add_data_property(type, value, name = @values[:name])
        type = type.to_s.camelize(:lower)
        @result << Statement.new(resolve_uri(name), VOC[type], value)
      end

      def add_object_property(parent_uri, type, child_uri)
        parent_uri = RDF::URI(parent_uri) if parent_uri.is_a?(String)
        type = type.to_s.camelize
        @result << Statement.new(parent_uri, VOC["has#{type}"], child_uri)
      end
    end
  end
end
