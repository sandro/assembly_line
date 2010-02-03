module AssemblyLine
  class Constructor
    extend Forwardable

    def_delegators :rspec_context, :let, :before

    attr_reader :name, :code_block, :rspec_context, :options

    def initialize(name, code_block)
      @name = name
      @code_block = code_block
    end

    def assemble(context, options)
      @options = options
      @rspec_context = context
      instance_eval(&code_block)
      self
    end

    def invoke(*methods)
      if methods.any?
        methods.each do |name|
          before_all name
        end
      else
        before_all name
      end
    end

    def depends_on(*constructors)
      if options[:depends_on]
        constructors = Array(options[:depends_on])
      end
      constructors.each do |name|
        AssemblyLine.assemble(name, rspec_context)
      end
    end

    protected

    def before_all(method_name)
      before(:all) { send(method_name) }
    end
  end
end
