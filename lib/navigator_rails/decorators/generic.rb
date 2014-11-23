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
      def child_count
        resource.children.count
      end
      def has_visible_children
        begin
          children.collect do |child|
            child.constraint
          end.reduce(:|)
        rescue NoMethodError
          false
        end
      end
      def children_except params={}
        resource.children_except(params)
      end
      def children params={}
        resource.children(params)
      end
      def draw_children elements=nil
        elements ||= resource.children
        elements.collect do |child|
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