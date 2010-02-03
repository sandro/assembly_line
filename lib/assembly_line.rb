require 'forwardable'
require 'assembly_line/registry'
require 'assembly_line/constructor'

module AssemblyLine
  VERSION = "0.1.0".freeze

  def self.define(name, &block)
    Registry.add(name, block)
  end

  def self.assemble(name, rspec_context, options={})
    Registry.locate(name).assemble(rspec_context, options)
  end

  def Assemble(name, options={})
    AssemblyLine.assemble(name, self, options)
  end
end
