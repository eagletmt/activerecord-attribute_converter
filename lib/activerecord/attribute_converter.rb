require 'active_support/lazy_load_hooks'
require 'activerecord/attribute_converter/base'
require 'activerecord/attribute_converter/predicate_builder'
require 'activerecord/attribute_converter/relation'
require 'activerecord/attribute_converter/version'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:extend, ActiveRecord::AttributeConverter::Base)

  ActiveRecord::PredicateBuilder.singleton_class.class_eval do
    include ActiveRecord::AttributeConverter::PredicateBuilder
    alias_method_chain :build_from_hash, :attribute_converter
  end

  ActiveRecord::Relation.class_eval do
    # Use alias_method_chain instead of Module#prepend here.
    # In Rails 4, activerecord-deprecated_finders monkey-patches update_all and
    # the combination of alias_method_chain and prepend causes some trouble.
    include ActiveRecord::AttributeConverter::Relation
    alias_method_chain :update_all, :attribute_converter
  end
end
