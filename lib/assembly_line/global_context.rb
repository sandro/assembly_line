module AssemblyLine
  module GlobalContext
    extend self

    def let(name, &block)
      define_method name do
        let_values[name] ||= instance_eval(&block)
      end
      ::Kernel.def_delegator :assembly_line_global_context, name
    end

    # there are no tests so just run the block
    def before(scope=:each, &block)
      instance_eval &block
    end

    def clear
      instance_variables.each do |name|
        instance_variable_set(name, nil)
      end
    end

    protected

    def let_values
      @let_values ||= {}
    end

    attr_writer :context
  end
end
