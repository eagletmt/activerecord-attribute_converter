module ActiveRecord
  module AttributeConverter
    module Base
      class Serializer
        def initialize(converter)
          @converter = converter
        end

        def dump(obj)
          @converter.internalize(obj)
        end

        def load(obj)
          @converter.externalize(obj)
        end
      end

      def apply_converter(attr, converter)
        unless @attribute_converters
          @attribute_converters = {}
        end

        serialize attr, Serializer.new(converter)
        self.attribute_converters[attr.to_s] = converter
      end

      def attribute_converters
        @attribute_converters || {}
      end
    end
  end
end
