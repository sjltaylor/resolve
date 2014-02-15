require 'spec_helper'

describe 'dependencies declarations' do
  describe 'the set of dependencies derived from class and module hierarchy' do

    describe 'for a module' do
      module M
        depends_on :fire, :the_sun
      end
      let(:expected_dependencies) { [:fire, :the_sun] }
      it "has dependencies" do
        M.dependencies.sort.should == expected_dependencies.sort
      end
    end
    describe 'for a class' do
      class A
        depends_on :cats, :the_sun
      end
      let(:expected_dependencies) { [:cats, :the_sun] }
      it "has dependencies" do
        A.dependencies.sort.should == expected_dependencies.sort
      end
    end
    describe 'for a subclass of a class with dependencies' do
      class A
        depends_on :cats, :the_sun
      end
      class B < A
        depends_on :dogs, :the_sun
      end
      let(:expected_dependencies) { [:cats, :dogs, :the_sun] }
      it "has dependencies" do
        B.dependencies.sort.should == expected_dependencies.sort
      end
    end
    describe 'for a subclass with a module included' do
      module M
        depends_on :fire, :the_sun
      end
      class A
        depends_on :cats, :the_sun
      end
      class B < A
        depends_on :dogs, :the_sun
      end
      class C < B
        include M
        depends_on :water, :the_sun
      end

      let(:expected_dependencies) { [:fire, :the_sun, :water, :cats, :dogs] }
      it "has dependencies" do
        C.dependencies.sort.should == expected_dependencies.sort
      end
    end
    describe 'for an instance of a user defined class' do
      class A
        depends_on :cats, :the_sun
      end
      class D < A
        def initialize
          depends_on :extras, :the_sun
        end
      end
      let(:expected_dependencies) { [:extras, :the_sun, :cats] }
      it "has dependencies" do
        D.new.dependencies.sort.should == expected_dependencies.sort
      end
    end
    describe 'for a module which extends itself' do
      module O
        depends_on :bacon, :the_sun
        extend self
      end
      let(:expected_dependencies) { [:bacon, :the_sun] }
      it "has dependencies" do
        O.dependencies.sort.should == expected_dependencies.sort
      end
    end
    describe 'for a class which extends a module' do
      module M
        depends_on :fire, :the_sun
      end
      class E
        extend M
        depends_on :insulin, :the_sun
      end
      let(:expected_dependencies) { [:insulin, :the_sun, :fire] }
      it "has dependencies" do
        E.dependencies.sort.should == expected_dependencies.sort
      end
    end
    describe 'for a module with module functions' do
      module P
        module_function
        depends_on :money, :the_sun
      end
      let(:expected_dependencies) { [:money, :the_sun] }
      it "has dependencies" do
        P.dependencies.sort.should == expected_dependencies.sort
      end
    end
    describe 'for a module which extends another module' do
      module M
        depends_on :fire, :the_sun
      end
      module Q
        extend M
        depends_on :paper, :the_sun
      end
      let(:expected_dependencies) { [:fire, :the_sun, :paper] }
      it "has dependencies" do
        Q.dependencies.sort.should == expected_dependencies.sort
      end
    end
  end
end
