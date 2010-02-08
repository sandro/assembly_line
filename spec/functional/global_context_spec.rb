require 'spec_helper'

global_assembly_set_up = lambda do
  AssemblyLine.define(:global_assembly) do
    let(:foo) { @bar +=1 }
    before do
      @bar = 0
    end
  end
  Assemble(:global_assembly)
end

def call_global_assembly(count = 5)
  (count - 1).times { foo }
  foo
end

describe "in the global context" do
  before(:all) do
    global_assembly_set_up.call
  end

  it "defined the method within AssemblyLine::GlobalContext" do
    AssemblyLine::GlobalContext.should respond_to(:foo)
  end

  it "does not increase the value because the method is memoized" do
    call_global_assembly.should == 1
  end
end
