require 'resolve/version'
require 'active_support/inflector'

module Resolve
  extend self
  def accessor_name_for(dependency)
    dependency.to_s.split('/')[-1].underscore.to_sym
  end
  def satisfy(object, opts={})
    return object unless object.respond_to?(:dependencies)
    object.dependencies.each do |dependency|
      name = accessor_name_for(dependency)
      dependency = opts[name] || resolve(dependency, opts)
      object.send("#{name}=", dependency)
    end
    return object
  end
  def resolve(dependency, opts={})
    klass = dependency.to_s.classify.constantize
    instance = klass.allocate
    satisfy(instance, opts)

    if instance.private_methods.include? :initialize
      initialize_method = instance.method(:initialize)
      if initialize_method.arity.zero?
        instance.send(:initialize)
      else
        instance.send(:initialize, opts)
      end
    end

    return instance
  end
end
