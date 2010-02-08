require 'forwardable'
require 'assembly_line/registry'
require 'assembly_line/constructor'
require 'assembly_line/global_context'

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

module Kernel
  extend Forwardable

  def Assemble(name, options={})
    AssemblyLine.assemble(name, assembly_line_global_context, options)
  end

  protected

  def assembly_line_global_context
    AssemblyLine::GlobalContext
  end
end
