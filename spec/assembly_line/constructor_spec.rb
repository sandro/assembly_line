require 'spec_helper'

describe AssemblyLine::Constructor do
  let(:code_block) do
    lambda do
      let(:host) { :rochelle }
      let(:attendees) { [] }
    end
  end
  let(:constructor) { AssemblyLine::Constructor.new(:gathering, code_block) }

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
end
