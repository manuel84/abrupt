# @author Manuel Dudda
module Abrupt
  module Transformation
    # Transformation clas for client visit data
    class Rif
      def initialize(file)
        @file = file
      end

      def owl
        IO.foreach(@file) do |line|
          case line.strip
          when /^Document\(/
            # []      a :Document;
            #         :directives ();
            #         :payload <http://sample.org>.
            p 'start document'
          when /^Base\(<(\S+)>\)/
            # add base namespace:
            # Base(<http://example.com/people#>)
            p 'Base'
            p $1
          when /^Prefix\((\S+)\s+<(\S+)>\)/
            # add namespace:
            # Prefix(dc   <http://purl.org/dc/terms/>)
            p 'Namespace'
            p $1
            p $2
          when /^Group(\()?/
            p 'Group'
            if $1 # with parenthesis
            else # without parenthesis

            end

          when '('
            # clsoing parenthesis
          when /^Forall\s(\?\w+\s)*(\()$/
            # add vars:
            # Forall ?item ?deliverydate ?scheduledate ?diffduration ?diffdays (
            p 'vars'
            p $1
            p $2
          when /^(\(\*)?(.+)(\(*\))?/m
            # add anotation:
            if $1 || $2
              p 'annotation'
              if $1 && $2.nil? # opening parenthesis: (* "http://sample.org"^^rif:iri _pd[dc:publisher -> "http://www.w3.org/"^^rif:iri
              elsif $2 && $1.nil? # closing parenthesis: dc:date -> "2008-04-04"^^xs:date] *)
              else # one liner: (* "http://sample.org"^^rif:iri ... "^^xs:date] *)
              end
            end
          end
        end
      end
    end
  end
end
