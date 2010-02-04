require 'spec_helper'

describe AssemblyLine::Registry do
  let(:registry) { AssemblyLine::Registry.dup }
  let(:code_block) { lambda {} }

  after do
    registry.clear
  end

  describe "#add" do
    it "adds a new constructor to the list of registered assembly lines" do
      registry.add(:party, code_block)
      registry.list.should include(:party)
    end
  end

  describe "#list" do
    it "lists the registered assembly lines by name" do
      registry.add(:one, code_block)
      registry.add(:two, code_block)
      registry.list.should =~ [:one, :two]
    end
  end

  describe "#clear" do
    it "clears the registry" do
      registry.add(:one, code_block)
      registry.add(:two, code_block)
      expect do
        registry.clear
      end.to change { registry.list.size }.from(2).to(0)
    end
  end

  describe "#locate" do
    context "when AssemblyLine has been registered" do
      before do
        registry.add(:party, code_block)
      end

      it "returns the registered Constructor" do
        registry.locate(:party).should be_instance_of(AssemblyLine::Constructor)
      end
    end

    context "when AssemblyLine has not been registered" do
      it "raises an ArgumentError" do
        expect do
          registry.locate(:does_not_exist)
        end.to raise_error(ArgumentError, "AssemblyLine could not find definition for: ':does_not_exist'")
      end
    end
  end
end
