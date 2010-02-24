Assembly Line
=============

Assembly Line allows you to group together a series of rspec `let` statements which can later be evaluated to set up a specific state for your specs. It's an excellent compliment to factory_girl because you can use your factories to build up each component, then use AssemblyLine to bring them all together.

As a system grows in complexity, more objects are required to set up the necessary state to write tests. Sometimes you'll need to write a test that requires access to the beginning, middle, and end of a very large hierarchy, and AssemblyLine can expose each part of the hierarchy that you care about.

Installation
------------
    gem install assembly_line

Edit your *spec/spec_helper.rb*

    # unnecessary if you used config.gem 'assembly_line'
    require 'assembly_line'

    # I put my definitions inside of spec/support/ because my spec_helper loads everything in that directory
    require 'your_assembly_line_definitions'

    # remember to extend the module in your Rspec configuration block
    Spec::Runner.configure do |config|
      config.extend AssemblyLine
    end

Example
-------

### Assuming you have the following class

    class Party < Struct.new(:host, :attendees)
      attr_writer :drinks
      def drinks
        @drinks ||= []
      end
    end

### Place your AssemblyLine definitions in *spec/support/assemblies/party_assembly.rb*

    AssemblyLine.define(:drinks) do
      let(:drinks) { [:gin, :vodka] }
    end

    AssemblyLine.define(:party) do
      depends_on :drinks

      let(:host) { :rochelle }
      let(:attendees) { [:nick, :ellis, :coach] }
      let(:party) { @party = Party.new(host, attendees) }
      let(:party_crasher) { attendees << :crasher; :crasher }
    end

### Use your AssemblyLine in a test

    describe Party do
      Assemble(:party)
      before do
         puts "simple before block"
      end

      context "attendees" do
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
        it "does not include the list of standard drinks" do
          party.drinks.should_not include(drinks)
        end
      end
    end

### Use your AssemblyLine in an irb session

AssemblyLine works a little differently when using it in irb. Your `let` definitions will not be defined globally (see [e26a903](http://github.com/sandro/assembly_line/commit/e26a903)), instead you'll have to prefix all defined methods with `AssemblyLine`.

    >> require 'spec/support/assemblies'
    >> Assemble(:drinks)
    => #<AssemblyLine::Constructor:0x10049e958 @code_block=#<Proc:0x000000010049ea98@(irb):1>, @name=:drinks, @rspec_context=AssemblyLine::GlobalContext, @options={}>
    >>
    >> AssemblyLine.drinks # the `drinks` method is prefixed with AssemblyLine
    => [:gin, :vodka]


Thanks!
-------

- l4rk     (initial spike declaring modules and including them in the rspec context)
- veezus   (code contributions, introduced modular design / dependencies)
- bigtiger (named the project, contributor)
- leshill  (support and testing, suggested irb support)
- wgibbs   (suggested irb support)


Note on Patches/Pull Requests
-----------------------------

- Fork the project.
- Make your feature addition or bug fix.
- Add tests for it. This is important so I don't break it in a
  future version unintentionally.
- Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 Sandro Turriate. See MIT_LICENSE for details.
