require 'spec_helper'

describe "AssemblyLine in practice" do
  extend AssemblyLine

  class Party < Struct.new(:host, :attendees)
    attr_writer :drinks
    def drinks
      @drinks ||= []
    end
  end

  AssemblyLine.define(:before_block) do
    before(:each) do
      @feedback = "before called"
    end
  end

  AssemblyLine.define(:location) do
    let(:location) { "123 main st." }
  end

  AssemblyLine.define(:drinks) do
    let(:drinks) { [:gin, :vodka] }
  end

  AssemblyLine.define(:party) do
    depends_on :drinks

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

  describe "dependencies" do
    context "loading the built-in dependency" do
      Assemble(:party)
      it "loads the 'drinks' dependency when loading the party assembly" do
        party
        drinks.should == [:gin, :vodka]
      end
    end

    context "overriding the dependency" do
      Assemble(:party, :depends_on => :location)

      it "loads the 'location' assembly line when loading the party assembly" do
        party
        location.should == "123 main st."
      end

      it "does not load the built-in 'drinks' dependency" do
        party
        expect do
          drinks
        end.to raise_error(NameError)
      end
    end
  end

  describe "before blocks" do
    Assemble(:before_block)
    it "invoked the before block" do
      @feedback.should == "before called"
    end
  end

  describe "README example" do
    context "attendees" do
      Assemble(:party)

      it "does not count the host as an attendee" do
        party.attendees.should_not include(host)
      end
    end

    context "party crasher" do
      Assemble(:party).invoke(:party_crasher)

      it "exemplifies method invocation after assembly" do
        party.attendees.should include(:crasher)
      end
    end

    context "drinks" do
      Assemble(:party)

      it "does not include the list of standard drinks" do
        party.drinks.should_not include(drinks)
      end
    end
  end
end
