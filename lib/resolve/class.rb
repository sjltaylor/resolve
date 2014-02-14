class Class
  def depends_on *new_dependencies
    new_dependencies = new_dependencies.uniq
    dependencies.push(*new_dependencies)
    attr_accessor(*new_dependencies)
    return dependencies
  end
  def dependencies
    @dependencies ||= []
  end
  def resolve(opts={})
    require 'active_support/inflector'
    Resolve.resolve(self, opts)
  end
end