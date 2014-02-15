require 'spec_helper'

module ResolvingDependencies
  describe 'resolving dependencies' do

    describe 'instance construction behaviour' do
      class NoInit; end
      class Arity0Init
        attr_accessor :init
        def initialize
          self.init = true
        end
      end
      class Arity1Init
        attr_accessor :init
        def initialize(opts)
          self.init = opts
        end
      end
      it 'can create instances of class without an initialize method' do
        NoInit.resolve.should be_instance_of NoInit
      end
      it 'passes options into an initialize method if it has an arity of one' do
        opts = double(:opts)
        Arity1Init.resolve(opts).init.should  == opts
      end
      it 'does not pass options to classes with an initialize method with an arity of zero' do
        Arity0Init.resolve({}).init.should be true
      end
    end
    describe 'assigning options' do
      module M
        depends_on :cake, :chips
      end
      class A
        include M
        depends_on :cheese, :fish
        attr_accessor :opts
        def initialize
          self.opts = {}
          opts[:cake] = self.cake
          opts[:chips] = self.chips
          opts[:fish] = self.fish
          opts[:cheese] = self.cheese
        end
      end
      it 'assigns any dependencies which are available in the provided options' do
        opts = {
          cake: double(:cake),
          chips: double(:chips),
          fish: double(:fish),
          cheese: double(:cheese)
        }

        instance = A.resolve(opts)

        instance.opts[:cake].should eq(opts[:cake])
        instance.opts[:chips].should eq(opts[:chips])
        instance.opts[:fish].should eq(opts[:fish])
        instance.opts[:cheese].should eq(opts[:cheese])
      end
    end
    describe 'recursive resolution' do
      class ::MyDependency
      end
      class B
        depends_on :my_dependency
      end
      it 'calls resolve with any dependencies which are not in the provided options' do
        B.resolve.my_dependency.should be_instance_of(MyDependency)
      end
    end
  end
end