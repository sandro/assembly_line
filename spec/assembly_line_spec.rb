require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AssemblyLine do
  context "API" do
    subject { AssemblyLine }
    it { should respond_to(:define) }
    it { should respond_to(:assemble) }

  end

  describe ".define" do
    it "adds the AssemblyLine to the Registry" do
      definition = lambda {}
      AssemblyLine::Registry.should_receive(:add).with(:user_with_address, definition)
      AssemblyLine.define(:user_with_address, &definition)
    end
  end
end
