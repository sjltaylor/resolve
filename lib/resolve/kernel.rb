module Kernel
  def resolve(name, opts={})
    require 'active_support/inflector'
    name.to_s.classify.constantize.new(opts)
  end
end