class Class
  def depends_on *dependencies
    # get the names into a hash where keys are names
    # and values are arrays of occurences of those names
    names = dependencies.map do |dependency|
      Resolve.accessor_name_for(dependency)
    end.group_by{|name| name}

    names.each do |name, occurences|
      if occurences.count > 1
        raise NameError.new("more than one dependency of name '#{name}'")
      end
      attr_accessor name
    end

    define_method(:dependencies) do
      return dependencies
    end

    return dependencies
  end
end