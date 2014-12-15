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

      def customize_to_schema
        schema_file = "assets/schema/v1/#{keyname}.json"
        return unless File.exist?(schema_file)
        schema = ::JSON.load(File.read(schema_file))
        schema.deep_symbolize_keys!
        schema[:properties].each do |state_key, state_schema|
          set_value(state_schema, @values[state_key]) if @values[state_key]
        end
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
          [value].flatten.compact.each do |obj|
            next unless schema[:items][:type].eql?('object')
            obj.each do |k, v|
              next unless schema[:items][:properties][k]
              set_value(schema[:items][:properties][k], v, *(ref + [k]))
            end
          end
        else
          update_value(ref, value, schema) rescue nil
        end
      end

      def update_value(ref, value, schema)
        case ref.count
        when 1
          if @values[keyname][ref[0]].is_a? Array
            @values[keyname][ref[0]].each do |i|
              @values[keyname][ref[0]][i] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
            end
          else
            @values[keyname][ref[0]] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
          end
        when 2
          if @values[keyname][ref[0]].is_a? Array
            @values[keyname][ref[0]].each_with_index do |value, i|
              @values[keyname][ref[0]][i][ref[1]] = value[ref[1]].send *SCHEMA_MAPPING[schema[:type].to_sym]
            end
          elsif @values[keyname][ref[0]][ref[1]].is_a? Array
            @values[keyname][ref[0]][ref[1]].each_with_index do |value, i|
              @values[keyname][ref[0]][ref[1]][i] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
            end
          else
            @values[keyname][ref[0]][ref[1]] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
          end
        when 3
          if @values[keyname][ref[0]][ref[1]][ref[2]].is_a? Array
            @values[keyname][ref[0]][ref[1]][ref[2]].each_with_index do |value, i|
              @values[keyname][ref[0]][ref[1]][ref[2]][i] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
            end
          else
            @values[keyname][ref[0]][ref[1]][ref[2]] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
          end
        when 4
          if @values[keyname][ref[0]][ref[1]][ref[2]][ref[3]].is_a? Array
            @values[keyname][ref[0]][ref[1]][ref[2]][ref[3]].each_with_index do |value, i|
              @values[keyname][ref[0]][ref[1]][ref[2]][ref[3]][i] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
            end
          else
            @values[keyname][ref[0]][ref[1]][ref[2]][ref[3]] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
          end
        when 5
          if @values[keyname][ref[0]][ref[1]][ref[2]][ref[3]][ref[4]].is_a? Array
            @values[keyname][ref[0]][ref[1]][ref[2]][ref[3]][ref[4]].each_with_index do |value, i|
              @values[keyname][ref[0]][ref[1]][ref[2]][ref[3]][ref[4]][i] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
            end
          else
            @values[keyname][ref[0]][ref[1]][ref[2]][ref[3]][ref[4]] = value.send *SCHEMA_MAPPING[schema[:type].to_sym]
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
