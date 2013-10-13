require 'spec_helper'

describe Resolve do
  describe '#resolve' do
    before(:all) do
      # see the following required file for example definitions
      require 'support/test_dependencies'
    end

    def resolve(*args)
      Resolve.resolve(*args)
    end

    before(:each) { Resolve.stub(:satisfy) }

    describe 'called with a symbol' do
      it 'resolve to an instance of the denoted class' do
        resolve(:test_service1).should be_instance_of TestService1
      end
    end
    describe 'called with a string' do
      it 'resolve to an instance of the denoted class' do
        resolve('test_service1').should be_instance_of TestService1
      end
    end
    describe 'called with namespaced name' do
      it 'resolve to an instance of the denoted class' do
        resolve('test_namespace/service1').should be_instance_of TestNamespace::Service1
      end
    end

    describe 'when I dont specify any options' do
      it 'defaults to an empty hash' do
        resolve(:test_service4).opts.should == {}
      end
    end

    describe 'when the class specified has a constructor with zero arity' do
      it 'is invoked without arguments' do
        inst = resolve(:test_service2)
        inst.value.should == 123
      end
    end

    describe 'when the class specified has a constructor non-zero arity' do
      it 'is invoked with opts' do
        opts = double(:opts)
        inst = resolve(:test_service4, opts)
        inst.opts.should be opts
      end
    end

    describe 'when I do not specify options' do
      it 'is invoked with opts' do
        inst = resolve(:test_service4)
        inst.opts.should  == {}
      end
    end

    it 'satisfies the allocated object' do
      allocated_object = double(:allocated_object)
      TestService1.stub(:allocate).and_return(allocated_object)
      opts = {}
      resolve(:test_service1, opts)
      Resolve.should have_received(:satisfy).with(allocated_object, opts)
    end
  end

  describe '#accessor_name_for' do
    def accessor_name_for(dependency)
      Resolve.accessor_name_for(dependency)
    end

    context 'from a symbol' do
      it 'returns the symbol' do
        accessor_name_for(:dependency_described_by_symbol).should be :dependency_described_by_symbol
      end
    end
    context 'from a string' do
      it 'returns a symbol version of the string' do
        accessor_name_for('dependency_described_by_string').should == :dependency_described_by_string
      end
    end
    context 'the dependency is namespaced' do
      it 'uses the last segment of the name' do
        accessor_name_for('this/depended/important_service').should == :important_service
      end
    end
  end

  describe '#satisfy' do
    let(:options) { {} }
    before(:all) do
      # see the following required file for example definitions
      require 'support/test_dependencies'
    end

    let(:satisfied_service) { Resolve.satisfy(TestService3.allocate, options) }
    let(:test_service2) { double(:test_service2) }
    let(:service1) { double(:service1) }

    before(:each) do
      Resolve.stub(:resolve).with(:test_service2, options).and_return(test_service2)
      Resolve.stub(:resolve).with('test_namespace/service1', options).and_return(service1)
    end

    before(:each) { satisfied_service }

    context 'with dependecies provided in opts' do
      let(:options) { { test_service2: test_service2 } }

      it 'does not call resolve' do
        Resolve.should_not have_received(:resolve).with(:test_service2, any_args)
      end
      it 'assigns them to the instances attributes' do
        satisfied_service.test_service2.should be test_service2
      end
    end
    context 'with dependencies which are not provided in opts' do
      it 'are resolved with #resolve' do
        Resolve.should have_received(:resolve).with(:test_service2, options)
        Resolve.should have_received(:resolve).with('test_namespace/service1', options)
      end
      it 'assigns them to the instances attributes' do
        satisfied_service.service1.should be service1
        satisfied_service.test_service2.should be test_service2
      end
    end
    context 'when the object to satisfy does not respond to #dependencies' do
      it 'returns the object' do
        o = Object.new
        o.should_not respond_to(:dependencies)
        Resolve.satisfy(o).should be o
      end
    end
  end
end