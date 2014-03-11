module ActiveRecord
  module AttributeConverter
    module PredicateBuilder
      def build_from_hash_with_attribute_converter(*args)
        klass = args[0]
        attributes = args[1].stringify_keys

        klass.attribute_converters.each do |attr, converter|
          if attributes.has_key?(attr)
            attributes[attr] = converter.to_internal(attributes[attr])
          end
        end

        args[1] = attributes
        build_from_hash_without_attribute_converter(*args)
      end
    end
  end
end

ActiveRecord::PredicateBuilder.singleton_class.class_eval do
  include ActiveRecord::AttributeConverter::PredicateBuilder
  alias_method_chain :build_from_hash, :attribute_converter
end
