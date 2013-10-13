require 'resolve/class'

class TestService1
end

class TestService2
  attr_accessor :value
  def initialize
    self.value = 123
  end
end

class TestService3
  depends_on :test_service2, 'test_service1'
end

class TestService4
  attr_accessor :opts
  def initialize(opts)
    self.opts = opts
  end
end