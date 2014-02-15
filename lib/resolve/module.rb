class Module
  def depends_on *new_dependencies
    @__dependencies__ ||= Set.new
    @__dependencies__ += new_dependencies
    attr_accessor(*new_dependencies)
    return dependencies
  end

  def dependencies
    @__dependencies__ ||= []

    dependencies_accumulator = []

    dependencies_accumulator.push(*@__dependencies__)

    modules_accumulator = []

    if respond_to?(:included_modules)
      modules_accumulator.push(*included_modules)
    end

    modules_accumulator.reduce([]) do |memo, m|
      m_deps = m.instance_variable_get(:@__dependencies__)

      unless m_deps.nil?
        memo.push(*m_deps)
      end

      memo
    end.tap do |included_module_dependencies|
      dependencies_accumulator.push(*included_module_dependencies)
    end

    dependencies_accumulator.uniq
  end
end

