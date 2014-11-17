module NavigatorRails
  module Contextable
    attr_accessor :context      
    def patch_context
      return if @context.eval('self.methods.include? :navigator_builder')
      @context.eval('extend NavigatorRails::Builder')
    end
    def process code
      patch_context
      @context.eval(code)
    end
  end
end