module AssemblyLine
  module Registry
    extend self

    def add(name, block)
      constructors[name] = Constructor.new(name, block)
    end

    def list
      constructors.keys.dup
    end

    def locate(name)
      constructors[name] || raise(ArgumentError, "AssemblyLine could not find definition for: '#{name.inspect}'")
    end

    def clear
      constructors.clear
    end

    protected

    def constructors
      @constructors ||= {}
    end
  end
end
