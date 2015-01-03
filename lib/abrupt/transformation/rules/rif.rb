# @author Manuel Dudda
module Abrupt
  module Transformation
    # Transformation clas for client visit data
    class Rif
      include RDF

      def initialize(file)
        @file = file
        @checksum = Digest::SHA2.file(@file).hexdigest
        @graph = Graph.new
        @vocabularies = {
            wdm: WDM,
            rif: RDF::Vocabulary.new('http://www.w3.org/2007/rif#')
        }
        @sentences = RDF::List.new
      end

      def prefixes
        result = @vocabularies.dup
        result.each { |key, value| result[key] = value.to_s }
        result
      end

      def owl
        IO.foreach(@file) do |line|
          case line.strip
          when /^Document\(/
            # []      a :Document;
            #         :directives ();
            #         :payload <http://sample.org>.
            # p 'start document'
            bnode = Node.new
            @graph << [bnode, RDF.type, @vocabularies[:rif].Document]
            @graph << [bnode, @vocabularies[:rif].directives, RDF::List.new]
            @graph << [bnode, @vocabularies[:rif].payload, @vocabularies[:wdm]["Rules/rule#{@checksum}"]]
          when /^Base\(<(\S+)>\)/
            # add base namespace:
            # Base(<http://example.com/people#>)
            #p 'Base'
            #p $1
          when /^Prefix\((\S+)\s+<(\S+)>\)/
            # add namespace:
            # Prefix(dc   <http://purl.org/dc/terms/>)
            @vocabularies[$1.to_sym] = RDF::Vocabulary.new($2)
          when /^Group(\()?/
            @graph << [@vocabularies[:wdm]["Rules/rule#{@checksum}"], RDF.type, @vocabularies[:rif].Group]
            # <http://sample.org>     a :Group;
            if $1 # with parenthesis
            else # without parenthesis
            end
          when '('
            # clsoing parenthesis
          when /^Forall\s(\?\w+\s)*(\()$/
            # add vars:
            # Forall ?item ?deliverydate ?scheduledate ?diffduration ?diffdays (
            #p 'vars'
            #p $1
            #p $2
            bnode = Node.new
            bnode_formula = Node.new
            @sentences << [bnode, RDF.type, @vocabularies[:rif].Forall]
            @sentences << [bnode, @vocabularies[:rif].formula, bnode_formula]
            @graph << [bnode_formula, RDF.type, @vocabularies[:rif].Implies]
          when /^(\(\*)?(.+)(\(*\))?/m
            # add anotation:
            if $1 || $2
              #p 'annotation'
              if $1 && $2.nil? # opening parenthesis: (* " http : //s ample.org "^^rif:iri _pd[dc:publisher -> " http : // www.w3.org/"^^rif:iri
              elsif $2 && $1.nil? # closing parenthesis: dc:date -> " 2008-04-04 "^^xs:date] *)
              else # one liner: (* " http : //s ample.org "^^rif:iri ... "^^xs : date] *)
              end
            end
          end
        end
        @graph << [@vocabularies[:wdm]["Rules/rule#{@checksum}"], @vocabularies[:rif].sentences, @sentences]
        @graph
      end
    end
  end
end
