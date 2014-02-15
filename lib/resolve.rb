require 'resolve/version'
require 'resolve/module'
require 'resolve/class'
require 'active_support/inflector'
require 'active_support/core_ext/hash'

module Resolve
  module_function
  def resolve(dependency_name, opts={})
    dependency_name.to_s.camelize.constantize.resolve(opts)
  end
end
