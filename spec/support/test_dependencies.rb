require 'resolve/class'

module TestNamespace
  class Service1
  end
end

class TestService1
end

class TestService2
  attr_accessor :value
  def initialize
    self.value = 123
  end
end

class TestService3
  depends_on :test_service2, 'test_namespace/service1'
end

class TestService4
  attr_accessor :opts
  def initialize(opts)
    self.opts = opts
  end
end