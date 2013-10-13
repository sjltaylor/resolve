require 'spec_helper'
require 'resolve/class'

describe Class do
  let(:klass) { Class.new }
  let(:dependencies) do
    [
      :test_dependency,
      'test_service1',
      :test_service2,
      :my_service
    ]
  end
  let(:names) do
    [
      :test_dependency,
      :service,
      :test_service1,
      :test_service2,
      :my_service
    ]
  end

  describe '#depends_on' do
    let(:return_value) { klass.depends_on(*dependencies) }

    before(:each) do
      dependencies.each_with_index do |dependency, i|
        Resolve.stub(:accessor_name_for).with(dependency).and_return(names[i])
      end
    end

    def depends_on(dependencies=dependencies)
      klass.depends_on(*dependencies)
    end

    it 'takes and returns a list of dependency names' do
      depends_on.should == dependencies
    end

    describe 'when there is a naming collision' do
      let(:colliding_dependencies) { dependencies * 2 }
      it 'raises a NameError noting that more than one dependency has the same name' do
        expect do
          depends_on(colliding_dependencies)
        end.to raise_error(NameError, "dependency 'test_dependency' is declared more than once")
      end
    end

    describe 'dependency accessors' do
      let(:dependencies) { [:a_dependency] }
      before(:each) { depends_on }

      def instance_methods
        klass.public_instance_methods - Object.public_instance_methods
      end

      it 'uses the dependency name as the accessor name' do
        instance_methods.should include(:a_dependency)
        instance_methods.should include(:a_dependency=)
      end
    end

    describe 'newly defined #dependencies' do
      it 'returns the dependencies for the class' do
        depends_on
        klass.new.dependencies.should == dependencies
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
    it 'returns the result of Resolve.resove' do
      expected_return = double(:expected_return)
      Resolve.stub(:resolve).and_return(expected_return)
      TestService1.resolve.should be expected_return
    end
    describe 'without opts' do
      it 'defaults to an empty hash' do
        TestService1.resolve
        Resolve.should have_received(:resolve).with(:test_service1, {})
      end
    end
    describe 'with opts' do
      it 'defaults to an empty hash' do
        opts = double(:opts)
        TestService1.resolve(opts)
        Resolve.should have_received(:resolve).with(:test_service1, opts)
      end
    end
  end
end
