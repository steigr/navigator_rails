module NavigatorRails
  class Navigator
    class << self
      def render path
        context   = binding.of_caller(1)

        Constraint.context=context
        Decorator.context=context

        path      = Item.normalize_path(path)
        resource  = Store.get(path)
        decorator = Decorator.for(:navigator)
        
        decorator.draw(resource).html_safe
      end
    end
  end
end