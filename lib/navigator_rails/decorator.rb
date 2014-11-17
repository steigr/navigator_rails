module NavigatorRails
  class Decorator
    include Singleton
    extend NavigatorRails::Contextable
    class << self
      def at params; Decorator.instance.at params; end
      def for decorator; Decorator.instance.for decorator; end
      def register type, decorator; Decorator.instance.register type, decorator; end
    end
    def initialize
      @decorators = {}
    end
    def at params={}
      return NavigatorRails.config[:decorators][params[:level]-1] if params[:level]
    end
    def for type
      @decorators[type] if @decorators[type]
    end
    def register type, decorator
      @decorators[type] = decorator
    end
  end
end