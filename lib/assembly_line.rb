require 'forwardable'
require 'assembly_line/registry'
require 'assembly_line/constructor'
require 'assembly_line/generic_context'

module AssemblyLine
  VERSION = "0.2.0".freeze
  extend SingleForwardable

  def self.assemble(name, context, options={})
    Registry.locate(name).assemble(context, options)
  end

  def self.define(name, &block)
    Registry.add(name, block)
  end

  def self.generic_context
    @generic_context ||= GenericContext.new
  end

  def Assemble(name, options={})
    AssemblyLine.assemble(name, self, options)
  end
end

module Kernel
  def Assemble(name, options={})
    AssemblyLine.assemble(name, AssemblyLine.generic_context, options)
  end
end
