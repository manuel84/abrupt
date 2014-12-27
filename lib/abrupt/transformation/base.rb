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
        @md5 = Digest::MD5
      end

      def self.customize_to_schema(values)
        keyname = name.split('::').last.downcase
        schema_file = File.join Abrupt.root, 'assets', 'schema', 'v1', "#{keyname}.json"
        return values unless File.exist?(schema_file)
        schema = ::JSON.load(File.read(schema_file))
        schema.deep_symbolize_keys!
        schema[:properties].each do |state_key, state_schema|
          set_value(state_schema, values[state_key]) if values.has_key?(state_key)
        end
        values
      end

      # rubocop:disable all
      def set_value(schema, value, *ref)
        return value unless schema && value # NAND
        case schema[:type]
        when 'object'
          schema[:properties].each do |k, schema_data|
            set_value(schema_data, value[k], *(ref + [k])) if value[k]
          end
        when 'array'
          # make sure that value is an array
          # subject service word to array
          [value].flatten.compact.each_with_index do |obj, i|
            next unless schema[:items][:type].eql?('object')
            obj.each do |k, v|
              next unless schema[:items][:properties][k]
              # set_value(schema[:items][:properties][k], v, *(ref + [i, k]))
            end
          end
        else
          if value == '424242'
            puts ref.inspect
            puts schema.inspect
          end
          update_value(ref, value, schema) rescue nil
        end
      end

      def update_value(ref, value, schema)
        key_string = '[ref[' + (0...ref.count).to_a.join(']][ref[') + ']]'
        val = @values[keyname]
        ref.each do |key|
          break if val.is_a?(Array) || !val.has_key?(key)
          val = val[key]
        end
        if value.is_a? Array
          value.each_with_index do |v, i|
            key_string = '[ref[' + (0...ref.count-1).to_a.join(']][ref[') + "]][#{i}][ref[#{ref.count-1}]]"
            eval "@values[keyname]#{key_string} = v.send(*SCHEMA_MAPPING[schema[:type].to_sym])"
          end
        else
          if val.is_a? Array
            val.each_with_index do |v, i|
              eval "@values[keyname]#{key_string}[i] = v.send(*SCHEMA_MAPPING[schema[:type].to_sym])"
            end
          else
            eval "@values[keyname]#{key_string} = value.send(*SCHEMA_MAPPING[schema[:type].to_sym])"
          end
        end
      end

      # rubocop:enable all

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
