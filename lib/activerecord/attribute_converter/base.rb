module ActiveRecord
  module AttributeConverter
    module Base
      extend ActiveSupport::Concern

      def internalize_attributes
        self.class.attribute_converters.each do |attr, converter|
          if attributes.has_key?(attr)
            send("#{attr}=", converter.to_internal(send(attr)))
          end
        end
      end

      def externalize_attributes
        self.class.attribute_converters.each do |attr, converter|
          if attributes.has_key?(attr)
            send("#{attr}=", converter.from_internal(send(attr)))
          end
        end
      end

      module ClassMethods
        def apply_converter(attr, converter)
          unless @attribute_converters
            install_attribute_converter
          end

          self.attribute_converters[attr.to_s] = converter
        end

        def install_attribute_converter
          @attribute_converters = {}

          before_save :internalize_attributes

          after_save :externalize_attributes
          after_find :externalize_attributes
        end

        def attribute_converters
          @attribute_converters || {}
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::AttributeConverter::Base)
