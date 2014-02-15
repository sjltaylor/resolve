require 'spec_helper'
require 'resolve/class'

describe Class do
  let(:klass) { Class.new }
  let(:dependencies) do
    [
      :test_dependency,
      :test_service1,
      :test_service2,
      :my_service
    ]
  end

  describe '#depends_on' do
    it 'returns #dependencies' do
      expected_dependencies = [:results]
      klass.stub(:dependencies) { expected_dependencies }
      klass.depends_on(:example_dependency).should == expected_dependencies
    end

    describe 'when there is a naming collision' do
      it 'does not result in duplicates' do
        klass.depends_on(*(dependencies * 2))
        klass.dependencies.sort.should == dependencies.sort
      end
    end

    describe 'multiple calls' do
      it 'adds to the dependencies' do
        klass.depends_on(*dependencies)
        klass.depends_on :another_thing
        klass.dependencies.sort.should == dependencies.concat([:another_thing]).sort
      end
    end

    describe 'dependency accessors' do
      let(:dependencies) { [:a_dependency] }
      before(:each) { klass.depends_on(*dependencies) }

      def instance_methods
        klass.public_instance_methods - Object.public_instance_methods
      end

      it 'defines a setter' do
        setter = klass.instance_method(:a_dependency=)
        setter.arity.should == 1
      end

      it 'defines a getter' do
        getter = klass.instance_method(:a_dependency)
        getter.arity.should == 0
      end
    end
  end

  describe '#depencies' do
    it 'returns an empty array by default' do
      Class.new.dependencies.should == []
    end
    describe 'subclassing' do
      it 'inherits its parents dependencies' do
        klass.depends_on(*dependencies)
        subklass = Class.new(klass)
        subklass.depends_on(:another_thing)
        subklass.dependencies.sort.should == (dependencies + [:another_thing]).sort
      end
      it 'does not duplicate its parents dependencies' do
        klass.depends_on(*dependencies)
        subklass = Class.new(klass)
        subklass.depends_on(*dependencies)
        subklass.dependencies.sort.should == dependencies.sort
      end
    end
  end

  describe '#resolve' do
    before(:all) do
      # see the following required file for example definitions
      require 'support/test_dependencies'
    end
    before(:each) do
      Resolve.stub(:resolve)
    end
    it 'returns the result of Resolve.resolve' do
      expected_return = double(:expected_return)
      Resolve.stub(:resolve).and_return(expected_return)
      TestService1.resolve.should be expected_return
    end
    describe 'without opts' do
      it 'defaults to an empty hash' do
        TestService1.resolve
        Resolve.should have_received(:resolve).with(TestService1, {})
      end
    end
    describe 'with opts' do
      it 'defaults to an empty hash' do
        opts = double(:opts)
        TestService1.resolve(opts)
        Resolve.should have_received(:resolve).with(TestService1, opts)
      end
    end
  end
end
