class Class
  def dependencies

    dependencies_accumulator = super

    dependencies_accumulator.push(*@__dependencies__)

    if respond_to?(:superclass) && !superclass.nil?
      dependencies_accumulator.push(*superclass.dependencies)
    end

    dependencies_accumulator.uniq
  end

  def resolve(opts={})
    instance = allocate

    dependencies.each do |name|
      dependency = opts.has_key?(name) ? opts[name] : Resolve.resolve(name, opts)
      instance.send("#{name}=", dependency)
    end

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

