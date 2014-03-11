require 'active_support/lazy_load_hooks'
require 'activerecord/attribute_converter/version'

ActiveSupport.on_load(:active_record) do
  require 'activerecord/attribute_converter/base'
  require 'activerecord/attribute_converter/relation'
  require 'activerecord/attribute_converter/predicate_builder'
end
