module NavigatorRails
  class Constraint
    include Singleton
    extend NavigatorRails::Contextable
    class << self
      def default; NavigatorRails::Constraint.instance.default; end
    end
    def default
      NavigatorRails.config[:default_constraint]
    end
  end
end