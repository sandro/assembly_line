require 'spec_helper'

describe AssemblyLine::Constructor do
  let(:code_block) do
    lambda do
      depends_on :drinks

      let(:host) { :rochelle }
      let(:attendees) { [] }
    end
  end
  let(:constructor) { AssemblyLine::Constructor.new(:gathering, code_block) }
  let(:rspec_context) { mock('rspec_context', :let => nil, :depends_on => nil) }
  let(:options) { {:depends_on => :location} }

  describe "#assemble" do
    before do
      constructor.stub(:depends_on => nil)
    end
    it "persists context" do
      constructor.assemble(rspec_context, options)
      constructor.rspec_context.should == rspec_context
    end

    it "persists context" do
      constructor.assemble(rspec_context, options)
      constructor.options.should == options
    end

    it "evaluates the code block" do
      rspec_context.should_receive(:let).twice
      constructor.assemble(rspec_context, options)
    end

    it "returns itself" do
      constructor.assemble(rspec_context, options).should == constructor
    end
  end

  describe "#invoke" do
    context "no arguments provided" do
      it "calls the 'gathering' method" do
        constructor.should_receive(:invoke_in_setup).with(:gathering)
        constructor.invoke
      end
    end

    context "arguments provided" do
      it "calls the 'host' method" do
        constructor.should_receive(:invoke_in_setup).with(:host)
        constructor.invoke :host
      end

      it "calls the 'host' method followed by the 'attendees' method" do
        constructor.should_receive(:invoke_in_setup).with(:host, :attendees)
        constructor.invoke :host, :attendees
      end
    end
  end

  describe "#depends_on" do
    context "declared in the assembly" do
      it "attempts to assemble the 'drinks' dependency" do
        AssemblyLine.should_receive(:assemble).with(:drinks, rspec_context)
        constructor.assemble(rspec_context, {})
      end
    end

    context "passed in from options" do
      it "attempts to assemble the 'location' assembly" do
        AssemblyLine.should_receive(:assemble).with(:location, rspec_context)
        constructor.assemble(rspec_context, options)
      end
    end
  end
end
