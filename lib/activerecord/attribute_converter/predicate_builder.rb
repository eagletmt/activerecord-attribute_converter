module ActiveRecord
  module AttributeConverter
    module PredicateBuilder
      def build_from_hash_with_attribute_converter(*args)
        klass = args[0]
        unless klass.attribute_converters.empty?
          attributes = args[1].stringify_keys

          klass.attribute_converters.each do |attr, converter|
            if attributes.has_key?(attr)
              attributes[attr] = converter.internalize(attributes[attr])
            end
          end

          args[1] = attributes
        end
        build_from_hash_without_attribute_converter(*args)
      end
    end
  end
end
