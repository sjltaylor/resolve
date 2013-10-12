require 'spec_helper'
require 'resolve/class'

describe Class do
  let(:klass) { Class.new }
  let(:dependencies) do
    [
      :test_dependency,
      :'test_dependency/service',
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
        end.to raise_error(NameError, "more than one dependency of name 'test_dependency'")
      end
    end

    describe 'dependency accessors' do
      let(:dependencies) { [double(:dependency)] }
      before(:each) { Resolve.stub(:accessor_name_for).and_return('a_dependency') }
      before(:each) { depends_on }

      def instance_methods
        klass.public_instance_methods - Object.public_instance_methods
      end

      it 'uses the name returned by Resolve#dependency_name as the accessor name' do
        instance_methods.should include(:a_dependency)
        instance_methods.should include(:a_dependency=)
        Resolve.should have_received(:accessor_name_for).with(dependencies[0])
      end
    end

    describe '#dependencies' do
      it 'returns the dependencies for the class' do
        depends_on
        klass.new.dependencies.should == dependencies
      end
    end

    describe 'Class#new' do
      it 'calls Resolve#satisfy with an allocated instance and initializes and returns the result' do
        pending
      end
    end
  end
end
