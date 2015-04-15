# @author Manuel Dudda
module Abrupt
  module Transformation
    module Website
      # Complexity service
      # documentation see 'http://wba.cs.hs-rm.de/AbRUPt/service/complexity/public/index.php/api/v1/complexity'
      class Complexity < Base
        def add_individuals
          @uri = @parent_uri.slice!(-2, 2)
          return @result unless @values[keyname]
          # flatten vicram complexity
          @values[keyname][:vicramComplexity] =
              @values[keyname][:vicram].delete(:complexity)
          add_contrast_properties
          add_ratio_properties
          @values[keyname].delete :vicram
          super
        end

        def add_contrast_properties
          contrast = @values[keyname][:contrast]
          return unless contrast && contrast[:_1]
          contrast[:_1].each do |type, value|
            add_data_property(type, value)
          end
          @values[keyname].delete :contrast
        end

        def add_ratio_properties
          ratios = @values[keyname].delete :ratios
          add_page_sizes(ratios[:pageSize]) if ratios[:pageSize]
          add_img_tag_infos(ratios[:img_Tag]) if ratios[:img_Tag]
        end

        def add_page_sizes(page_size)
          page_size.each do |type, value|
            add_data_property(type, value)
          end
        end

        def add_img_tag_infos(img_tag)
          img_tag.each do |type, value|
            add_data_property(type, value)
          end
        end
      end
    end
  end
end
