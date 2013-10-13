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

    describe 'arguments' do
      describe 'opts' do
        context 'with no options specified' do
          it 'uses a default value' do
            expect { resolve(:test_service1) }.not_to raise_error
          end
        end
        context 'with options specified' do
          it 'passes the options to the newly initialized instance' do
            test_service4 = double(:test_service4, initialize: nil)
            TestService4.stub(:allocate).and_return(test_service4)
            opts = { one: 1 }
            resolve(:test_service4, opts)
            test_service4.should have_received(:initialize).with(opts)
          end
        end
      end
    end

    it 'satisfies the allocated object' do
      allocated_object = double(:allocated_object)
      TestService1.stub(:allocate).and_return(allocated_object)
      opts = {}
      resolve(:test_service1, opts)
      Resolve.should have_received(:satisfy).with(allocated_object, opts)
    end

    describe 'initializing the object' do
      it 'allocates and satifies the instance first' do
        allocated_object = double(:allocated_object, initialize: nil)
        TestService1.stub(:allocate).and_return(allocated_object)
        Resolve.stub(:satisfy) do |a|
          a.should_not have_received(:initialize)
        end
        resolve(:test_service1)
      end
      context 'when the instance does not have an initialize method' do
        it 'doesnt call initialize' do
          TestService1.instance_methods.should_not include(:initialize)
          expect{resolve(:test_service1)}.not_to raise_error
        end
      end
      context 'when the instance defines initialize with zero arity' do
        it 'calls initialize without opts' do
          TestService2.private_instance_methods.should include(:initialize)
          TestService2.instance_method(:initialize).arity.should be 0
          expect{resolve(:test_service2)}.not_to raise_error
        end
      end
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
      let(:options) { {} }

      it 'are resolved with #resolve' do
        Resolve.should have_received(:resolve).with(:test_service2, options)
        Resolve.should have_received(:resolve).with('test_namespace/service1', options)
      end
      it 'assigns them to the instances attributes' do
        satisfied_service.service1.should be service1
        satisfied_service.test_service2.should be test_service2
      end
    end
  end
end