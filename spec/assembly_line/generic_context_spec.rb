require 'spec_helper'

describe AssemblyLine::GenericContext do
  let(:generic_context) { AssemblyLine.generic_context }

  after { generic_context.clear }

  describe "#let" do
    it "defines the method on the GenericContext instance" do
      generic_context.let(:foobarish) { :bar }
      generic_context.foobarish.should == :bar
    end

    it "memoizes the defined method" do
      generic_context.instance_variable_set(:@count, 0)
      generic_context.let(:my_count) { @count += 1 }
      5.times { generic_context.my_count }
      generic_context.my_count.should == 1
    end

    it "adds a delegating method to AssemblyLine" do
      generic_context.let(:global_method) { :global }
      AssemblyLine.global_method.should == :global
    end
  end

  describe "#before" do
    it "runs the code block" do
      expect do
        generic_context.before { @done = true }
      end.to change { generic_context.instance_variable_get(:@done) }.from(nil).to(true)
    end
  end
end
