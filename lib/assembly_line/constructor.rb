module AssemblyLine
  class Constructor
    extend Forwardable

    def_delegators :context, :let, :before

    attr_reader :name, :code_block, :context, :options

    def initialize(name, code_block)
      @name = name
      @code_block = code_block
    end

    def assemble(context, options)
      @options = options
      @context = context
      instance_eval(&code_block)
      self
    end

    def invoke(*methods)
      if methods.any?
        invoke_in_setup *methods
      else
        invoke_in_setup name
      end
    end

    def depends_on(*constructors)
      if options[:depends_on]
        constructors = Array(options[:depends_on])
      end
      constructors.each do |name|
        AssemblyLine.assemble(name, context)
      end
    end

    protected

    def invoke_in_setup(*methods)
      before(:all) do
        methods.each do |method_name|
          send(method_name)
        end
      end
    end
  end
end
