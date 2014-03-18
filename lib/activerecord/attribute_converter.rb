require 'active_support/lazy_load_hooks'
require 'activerecord/attribute_converter/base'
require 'activerecord/attribute_converter/predicate_builder'
require 'activerecord/attribute_converter/relation'
require 'activerecord/attribute_converter/version'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, ActiveRecord::AttributeConverter::Base)

  ActiveRecord::PredicateBuilder.singleton_class.class_eval do
    include ActiveRecord::AttributeConverter::PredicateBuilder
    alias_method_chain :build_from_hash, :attribute_converter
  end

  ActiveRecord::Relation.class_eval do
    include ActiveRecord::AttributeConverter::Relation
    alias_method_chain :update_all, :attribute_converter
  end
end
