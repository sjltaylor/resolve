require 'resolve/version'
require 'resolve/class'
require 'active_support/inflector'
require 'active_support/core_ext/hash'

module Resolve
  extend self
  def satisfy(object, opts={})
    opts = opts.symbolize_keys
    object.class.dependencies.each do |name|
      name = name.to_sym
      dependency = opts.has_key?(name) ? opts[name] : resolve(name, opts)
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
