module NavigatorRails
  class Navigator
    class << self
      def render path
        Constraint.context = binding.of_caller(1)
        Decorator.context  = binding.of_caller(1)

        path      = Item.normalize_path(path)
        resource  = Store.get(path)
        decorator = Decorator.for(:navigator)
        
        decorator.draw(resource).html_safe
      end
    end
  end
end