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

Usage
-----
### let
    AssemblyLine.define(:drinks) do
      let(:drinks) { [:gin, :vodka] }
    end

This is the main usage of AssemblyLine. Let defines a method named after the first parameter and returns the return value of the provided block. Let memoizes the results so subsequent calls to the method will return the same result without re-running the block. Let delegates to rspec's implementation of let.


### before
    AssemblyLine.define(:killer_feature) do
      let(:killer_feature) { KillerFeature.new }
      before do
        KillerFeature.delete_all
        killer_feature.save!
      end
    end

You can use rspec's before blocks within an AssemblyLine definition. This is a simple delegate so `before`, `before(:each)`, and `before(:all)` are all supported. You can even reference your `let` definitions within a before block.

### depends_on
    AssemblyLine.define(:user_with_expired_cc) do
      let(:user) do
        Factory(:confirmed_user).tap do |u|
          u.credit_card.update_attribute :expiration_date, 1.year.ago
        end
      end
    end

    AssemblyLine.define(:subscription_with_invalid_cc) do
      depends_on :user_with_expired_cc
      let(:subscription) { Factory(:subscription, :user => user) }
    end

You can utilize other AssemblyLine definitions with `depends_on`. It takes a list of AssemblyLine definitions to load. This allows you to make modular AssemblyLines which can be used throughout your spec suite.

### invoke
    AssemblyLine.define(:drinks) do
      let(:drinks) do
        [ Factory(:drink, :name => :gin), Factory(:drink, :name => :vodka) ]
      end
    end

    describe "Drinks#index" do
      Assemble(:drinks).invoke
      it "lists the drinks" do
        visit drinks_path
        response.should contain(drinks.first.name)
        response.should contain(drinks.last.name)
      end
    end

Invoke takes a list of method names to call after assembly. If no arguments are provided, AssemblyLine will call a method named after the AssemblyLine itself, in this case `drinks` will be called. Note, these methods are called in a `before(:all)` block.

Let definitions are lazily evaluated which means sometimes the expected data isn't available until it's too late. In the above example, if I didn't call `invoke` the drinks index page would be empty.

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
