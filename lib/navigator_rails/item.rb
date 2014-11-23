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
    attr_accessor :path, :order, :type, :active_on, :active_controller
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
    def children params={}
      children = Store.children_of self
      children.collect do |child|
        params.each do |attribute,value|
          child=nil and break unless child and child.send(attribute) == value
        end
        child
      end.compact
    end
    def children_except params={}
      children = Store.children_of self
      children.collect do |child|
        params.each do |attribute,value|
          child=nil and break if child and child.send(attribute) == value
        end
        child
      end.compact
    end
    def active
      return unless @active_on
      return unless Constraint.process('controller').class == @active_controller
      return "active" if @active_on == :all
      return unless Constraint.process('params')['action'].to_sym == @active_on
      "active"
    end
  end
end