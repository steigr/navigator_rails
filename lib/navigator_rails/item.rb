module NavigatorRails
  class Item
    include ActiveModel::Model
    class << self
      def level_of path
        path.count('/')
      end
      def normalize_path path
        path = path.to_s
        path = "/#{path}" unless path =~ /^\//
        path
      end
    end
    attr_accessor :path, :order, :type
    attr_writer :content, :constraint
    def save
      self.type ||= Decorator.at level: self.level
      Store.add self
    end
    def level
      Item.level_of self.path 
    end
    def relative_path
      File.basename path
    end
    def decorator
      Decorator.for self.type
    end
    def content
      Decorator.process(@content.to_s) rescue Store.delete self
    end
    def constraint
      Constraint.process(@constraint.to_s) rescue Store.delete self
    end
  end
end