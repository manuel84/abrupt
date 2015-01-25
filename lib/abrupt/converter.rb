# @author Manuel Dudda
require 'singleton'
require 'rest_client'
require 'gyoku'
require 'rdf'
require 'linkeddata'
require 'active_support'
require 'active_support/core_ext'
Dir[File.dirname(__FILE__) + '/transformation/*.rb',
    File.dirname(__FILE__) + '/transformation/website/*.rb',
    File.dirname(__FILE__) + '/transformation/client/*.rb'].each do |file|
  require file
end

# Abrupt Converter
module Abrupt
  # Converter
  class Converter
    include Singleton
    include RDF
    attr_accessor :hsh, :values, :result, :format, :uri

    def init(options = {})
      @format = options[:format].try(:to_sym) || :turtle
      @result = Repository.new
    end

    def append_tbox
      @result << Repository.load(VOC_FILE)
    end

    def append_website_data(hsh)
      init_hsh(hsh)
      @uri = URI(@hsh[:website][:domain])
      init_website
      perform
    end

    def init_website
      domain = RDF::URI("#{VOC}Website/#{@uri}")
      @result << Statement.new(domain, RDF.type, VOC.Website)
      @result << Statement.new(domain, VOC.hostName, @uri.host)
    end

    def init_hsh(hsh)
      hsh = Hash.from_xml(File.read(hsh)) unless hsh.is_a?(Hash)
      @hsh = hsh.deep_symbolize_keys
      return unless @hsh[:website]
      @hsh[:website][:url].each_with_index do |value, i|
        Transformation::Website::Base.subclasses.each do |transformation_class|
          @hsh[:website][:url][i] =
              transformation_class.customize_to_schema(value)
        end
      end
    end

    def self.xml(hsh)
      Gyoku.xml hsh
    end

    def self.json(hsh)
      hsh.to_json
    end

    def add_to_result(statements)
      statements.each { |stmt| @result << stmt }
    end

    def perform
      website = ['Website', @uri.to_s]
      @hsh[:website][:url].each do |url|
        page = ['Page', url[:name].append_last_slash]
        page_transformator = Transformation::Base.new(website, page)
        add_to_result page_transformator.add_individuals # add Page
        next unless url[:state]
        perform_states url[:state], website + page
      end
    end

    def perform_states(states, parent_uri)
      states = states.is_a?(Array) ? states : [states]
      states.each do |value|
        state = ['State', value[:name]]
        # MAYBE empty?
        add_to_result Transformation::Base.new(parent_uri, state).result
        Transformation::Website::Base.subclasses.each do |transformation_class|
          t = transformation_class.new(parent_uri + state, nil, value)
          add_to_result t.add_individuals
        end
      end
    end

    def append_user_data(file)
      return unless file.is_a?(String) && File.exist?(file)
      xml = Hash.from_xml(File.read(file)).deep_symbolize_keys
      xml[:database][:visitor].ensure_to_a.each do |values|
        ip = values[:ip]
        next unless ip
        visitor = Transformation::Client::Visitor.new(
            ['Website', @uri.to_s], ['Visitor', ip], values)
        add_to_result visitor.add_individuals
        append_pages_for_visitor(visitor)
      end
      @result
    end

    def append_pages_for_visitor(visitor)
      pages = visitor.values[:pages][:page].ensure_to_a
      pages.each do |page|
        time = ::Abrupt.format_time(page[:entertime])
        Transformation::Client::Base.subclasses.each do |transformation_class|
          transformator = transformation_class.new(
              visitor.parent_uri + visitor.uri,
              ['Visit', time], page
          )
          add_to_result transformator.add_individuals
        end
      end
    end

    def append_rules
      Dir.glob(RULES_DIR).each do |rule_directory|
        Dir.glob(File.join(rule_directory, '*')).each do |rule_file|
          rule = Repository.load(rule_file)
          add_to_result(rule.statements)
        end
      end
    end
  end
end
