require 'spec_helper'

describe "AssemblyLine in practice" do
  extend AssemblyLine

  class Party < Struct.new(:host, :attendees); end

  AssemblyLine.define(:party) do
    let(:host) { :rochelle }
    let(:attendees) { [:nick, :ellis, :coach] }
    let(:party) { @party = Party.new(host, attendees) }
    let(:party_crasher) { attendees << :crasher; :crasher }
    let(:new_host) { party.host = :bob }
  end

  describe "invoking a method at assembly time" do
    context "default invocation" do
      Assemble(:party).invoke
      it "has set up a party instance variable without explicitly calling 'party'" do
        @party.should be_instance_of(Party)
      end
    end

    context "invoking one method" do
      Assemble(:party).invoke(:party_crasher)
      it "added a party crasher to the party" do
        attendees.should include(:crasher)
      end
    end

    context "invoking many methods" do
      Assemble(:party).invoke(:party_crasher, :new_host)
      it "added a party crasher to the party" do
        attendees.should include(:crasher)
      end

      it "changed the host to 'bob'" do
        party.host.should == :bob
      end
    end
  end
end
