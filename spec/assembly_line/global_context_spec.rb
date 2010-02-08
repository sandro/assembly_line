require 'spec_helper'

describe AssemblyLine::GlobalContext do
  let(:global_context) { AssemblyLine::GlobalContext }
  after { global_context.clear }

  describe "#let" do
    it "defines the method within AssemblyLine::GlobalContext" do
      global_context.let(:foobarish) { :bar }
      global_context.foobarish.should == :bar
    end

    it "memoizes the defined method" do
      global_context.instance_variable_set(:@count, 0)
      global_context.let(:my_count) { @count += 1 }
      5.times { global_context.my_count }
      global_context.my_count.should == 1
    end

    it "tells Kernel to delegate this method to AssemblyLine::GlobalContext" do
      global_context.let(:global_method) { :global }
      Kernel.global_method.should == :global
    end
  end

  describe "#before" do
    it "runs the code block" do
      expect do
        global_context.before { @done = true }
      end.to change { global_context.instance_variable_get(:@done) }.from(nil).to(true)
    end
  end
end
