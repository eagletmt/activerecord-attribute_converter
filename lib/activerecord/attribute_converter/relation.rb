module ActiveRecord
  module AttributeConverter
    module Relation
      def update_all_with_attribute_converter(*args)
        updates = args[0]
        conditions = args[1]
        options = args[2] || {}

        if !conditions && !options.present? && !@klass.attribute_converters.empty? && updates.is_a?(Hash)
          updates = updates.stringify_keys
          @klass.attribute_converters.each do |attr, converter|
            if updates.has_key?(attr)
              updates[attr] = converter.internalize(updates[attr])
            end
          end
          args[0] = updates
        end

        update_all_without_attribute_converter(*args)
      end
    end
  end
end
