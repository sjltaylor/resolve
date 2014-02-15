class Object
  def depends_on *new_dependencies
    @__dependencies__ ||= []
    @__dependencies__.push(*new_dependencies)
    @__dependencies__.uniq!
    return dependencies
  end
  def dependencies
    @__dependencies__ ||= []

    dependencies_accumulator = []

    dependencies_accumulator.push(*@__dependencies__)

    unless self.equal?(nil)
      dependencies_accumulator.push(*self.class.dependencies)
    end

    if respond_to?(:superclass)
      dependencies_accumulator.push(*superclass.dependencies)
    end

    included_modules_accumulator = []

    if respond_to?(:included_modules)
      included_modules_accumulator.push(*included_modules)
    end

    # find extended modules in the eigenclass
    included_modules_accumulator.push(*((class << self; self end).included_modules))

    included_module_dependencies = included_modules_accumulator.reduce([]) do |memo, m|
      m_deps = m.instance_variable_get(:@__dependencies__)

      unless m_deps.nil?
        memo.push(*m_deps)
      end

      memo
    end

    dependencies_accumulator.push(*included_module_dependencies)

    dependencies_accumulator.uniq
  end
end

class Class
  def self.dependencies
    []
  end
end

