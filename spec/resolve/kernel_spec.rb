require 'spec_helper'

describe 'Kernel#resolve' do
  describe 'called with a symbol' do
    it 'resolve to an instance of the denoted class' do
      resolve(:test_dependency).should be_instance_of TestDependency
    end
  end
  describe 'called with a string' do
    it 'resolve to an instance of the denoted class' do
      resolve(:test_dependency).should be_instance_of TestDependency
    end
  end
  describe 'called with namespaced name' do
    it 'resolve to an instance of the denoted class' do
      resolve(:'test_dependency/inner_class').should be_instance_of TestDependency::InnerClass
    end
  end
  describe 'options' do
    context 'with no options specified' do
      it 'uses a default value' do
        expect { resolve(:test_dependency) }.not_to raise_error
      end
    end
    context 'with options specified' do
      it 'passes the options to the newly initialized instance' do
        TestDependency.stub(:new)
        options = {one: 1}
        resolve(:test_dependency, options)
        TestDependency.should have_received(:new).with(options)
      end
    end
  end
end