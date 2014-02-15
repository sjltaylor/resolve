require 'spec_helper'

describe Resolve, '#resolve' do
  class Beans
  end

  it 'calls Class#resolve on the correct instance' do
    Beans.stub(:resolve)
    options = {one: 1}
    Resolve.resolve(:beans, options)
    Beans.should have_received(:resolve).with(options)
  end
end