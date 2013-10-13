class Class
  def depends_on *dependencies
    # get the names into a hash where keys are names
    # and values are arrays of occurences of those names
    names = dependencies.group_by{|name| name}

    names.each do |name, occurences|
      if occurences.count > 1
        raise NameError.new("dependency '#{name}' is declared more than once")
      end
      attr_accessor name
    end

    define_method(:dependencies) do
      return dependencies
    end

    return dependencies
  end
  def resolve(opts={})
    require 'active_support/inflector'
    Resolve.resolve(name.underscore.to_sym, opts)
  end
end