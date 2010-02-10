require 'spec_helper'

set_up_assembly = lambda do
  AssemblyLine.define(:global_assembly) do
    let(:foo) { @bar += 1 }
    before do
      @bar = 0
    end
  end
  Assemble(:global_assembly)
end

describe "in the global context" do
  before do
    set_up_assembly.call
  end

  it "defines the method on AssemblyLine.generic_context" do
    AssemblyLine.generic_context.should respond_to(:foo)
  end

  it "memoizes the value" do
    5.times { AssemblyLine.foo }
    AssemblyLine.foo.should == 1
  end
end
