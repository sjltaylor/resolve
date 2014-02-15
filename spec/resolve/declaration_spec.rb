require 'spec_helper'

module DependencyDeclarations

  describe 'dependencies declarations' do
    describe 'the set of dependencies derived from class and module hierarchy' do

      describe 'for a module' do
        module M
          depends_on :fire, :the_sun
        end
        expected_dependencies = [:fire, :the_sun]
        it "has dependencies #{expected_dependencies}" do
          M.dependencies.sort.should == expected_dependencies.sort
        end
      end
      describe 'for a class' do
        class A
          depends_on :cats, :the_sun
        end
        expected_dependencies = [:cats, :the_sun]
        it "has dependencies #{expected_dependencies}" do
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
        expected_dependencies = [:cats, :dogs, :the_sun]
        it "has dependencies #{expected_dependencies}" do
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

        expected_dependencies = [:fire, :the_sun, :water, :cats, :dogs]
        it "has dependencies #{expected_dependencies}" do
          C.dependencies.sort.should == expected_dependencies.sort
        end
      end
      describe 'for a module with module functions' do
        module P
          module_function
          depends_on :money, :the_sun
        end
        expected_dependencies = [:money, :the_sun]
        it "has dependencies #{expected_dependencies}" do
          P.dependencies.sort.should == expected_dependencies.sort
        end
      end
    end
  end
end