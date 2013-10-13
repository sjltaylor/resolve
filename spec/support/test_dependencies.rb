require 'resolve/class'

module TestNamespace
  class Service1
  end
end

class TestService1
end

class TestService2
  def initialize
  end
end

class TestService3
  depends_on :test_service2, 'test_namespace/service1'
end

class TestService4
  def initialize(opts)
  end
end