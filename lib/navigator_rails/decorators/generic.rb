module NavigatorRails
  module Decorators
    module Generic
      class << self
        def included base
          type      = base.to_s.demodulize.downcase.to_sym
          decorator = base
          base.send(:extend,NavigatorRails::Decorators::Generic)
          decorator.type = type
          base.send(:include,Singleton)
          NavigatorRails::Decorator.register type, decorator.instance
        end
      end
      attr_accessor :type
      def resource
        @resource
      end
      def children_with params={}
        children = Store.children_of resource
        if params[:except]
          children = children.collect do |child|
            unless child.type
              child
            else
              child unless child.type.to_sym == params[:except].to_sym
            end
          end.compact
        end
        if params[:only]
          children = children.collect do |child|
            next unless child.type
            child if child.type.to_sym == params[:except].to_sym
          end.compact
        end
        children
      end
      def child_count
        children_with.count
      end
      def has_visible_children
        children_with.collect do |child|
          child.constraint
        end.reduce(:|)
      end
      def children params={}
        children = children_with params
        children.collect do |child|
          next unless child.constraint
          child.decorator.draw(child).html_safe
        end.join
      end
      def children_of resource
      end
      def draw resource
        old_resource = @resource
        @resource = resource
        output = ERB.new(template).result(binding).html_safe
        @resource = old_resource
        output
      end
    end
  end
end