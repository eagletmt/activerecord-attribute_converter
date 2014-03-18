module ActiveRecord
  module AttributeConverter
    module Relation
      # Rails 3.2:  update_all(updates, conditions = nil, options = {})
      # Rails 4.0:  update_all(updates)
      # Rails 4.1:  update_all(updates)
      def update_all_with_attribute_converter(*args)
        updates = args[0]
        conditions = args[1]
        options = args[2] || {}

        if !conditions && !options.present? && !@klass.attribute_converters.empty? && updates.is_a?(Hash)
          # Only `update_all(attr: value)` form is supported.
          # `update_all(['attr = ?', value])` and `update_all("attr = #{value}")`
          # form is NOT supported because we cannot convert values safely.
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
