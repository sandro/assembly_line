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

  describe ".assemble" do
    let(:rspec_context) { mock('rspec context') }

    context "cannot locate the AssemblyLine" do
      it "raises an error" do
        expect do
          AssemblyLine.assemble(:does_not_exist, rspec_context)
        end.to raise_error(ArgumentError)
      end
    end

    context "AssemblyLine exists" do
      it "assembles the AssemblyLine" do
        constructor = mock('constructor')
        constructor.should_receive(:assemble).with(rspec_context, options)
        AssemblyLine::Registry.stub(:locate => constructor)
        AssemblyLine.assemble(:party, rspec_context)
      end
    end
  end

  describe "#Assemble" do
    it "delegates to AssemblyLine.assemble" do
      klass = Class.new do
        extend AssemblyLine
      end
      AssemblyLine.should_receive(:assemble).with(:party, klass, {})
      klass.Assemble(:party)
    end
  end
end
