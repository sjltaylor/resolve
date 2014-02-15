class Class
  def depends_on *new_dependencies
    new_dependencies = new_dependencies.uniq
    @dependencies ||= []
    @dependencies.push(*new_dependencies)
    attr_accessor(*new_dependencies)
    return dependencies
  end
  def dependencies
    @dependencies ||= []

    superclass_dependencies = if superclass.nil?
      []
    else
      superclass.dependencies
    end

    (superclass_dependencies + @dependencies).uniq
  end
  def resolve(opts={})
    require 'active_support/inflector'
    Resolve.resolve(self, opts)
  end
end