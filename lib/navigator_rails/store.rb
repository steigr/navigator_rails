require 'sourcify'

module NavigatorRails
  class Store
    include Singleton
    class << self
      def add item; Store.instance.add item; end
      def get path; Store.instance.get path; end
      def delete item; Store.instance.delete item; end
      def collect;  Store.instance.collect; end
      def children_of resource; Store.instance.children_of resource; end
      def process_items; Store.instance.process_items; end
      def process_config_builders; Store.instance.process_config_builders; end
    end
    def initialize
      @items     ||= []
    end
    def items
      @items
    end
    def add item
      @items.each do |dbitem|
        return if dbitem.path == item.path
      end
      @items << item
      fill_gaps
    end
    def get path
      @items.collect do |item|
        item if item.path == path
      end.compact.first
    end
    def delete item
      @items.delete(item)
    end
    def children_of resource
      unordered_items = @items.collect do |item|
        next unless item.path  =~ /^#{resource.path}\//
        next unless item.level == resource.level+1
        [item, item.order]
      end.compact
      orderable_items = unordered_items.collect do |item,order|
        [order,item] if order
      end.compact
      items = []
      items += orderable_items.sort.to_h.values unless orderable_items.empty?
      items += unordered_items.collect do |item,order|
        item unless order
      end.compact
    end
    def process_config_builders
      NavigatorRails.config.each do |param,value|
        next unless param =~ /^build_/
        case param
        when :build_devise_at
          parent_path = Item.normalize_path value
          Item.new(path: "#{parent_path}/Profile", type: :link, constraint: 'user_signed_in?', content: "link_to('Profile', edit_user_registration_url)").save
          Item.new(path: "#{parent_path}/SignOut", type: :link, constraint: 'user_signed_in?', content: "link_to('Sign Out', destroy_user_session_url, method: :delete)").save
          Item.new(path: "#{parent_path}/SignIn", type: :link, constraint: 'not user_signed_in?', content: "link_to('Sign In', new_user_session_url)").save
          Item.new(path: "#{parent_path}/SignUp", type: :link, constraint: 'not user_signed_in?', content: "link_to('Sign Up', new_user_registration_url)").save
        when :build_brand
          Item.new(type: :brand, type: :brand, path: value[:path], content: "link_to(raw('#{value[:content]}'),root_url, class: 'navbar-brand')").save
        end
      end
    end
    def get_controller dir, file
      begin 
        return file.sub(/^#{dir}\//, '').sub(/\.rb$/,'').classify.constantize
      rescue NameError
        return
      end
    end
    def register_controller controller
      NavigatorRails.config[:controllers] << controller
    end
    def get_items_of controller
      if defined?(controller.navigator_rails_items)
        register_controller controller
        return unless controller.navigator_rails_items
        controller.navigator_rails_items.collect do |item|
          item.save
        end
      end
    end
    def collect
      NavigatorRails.config[:search_at].each do |dir|
        Dir["#{dir}/**/*.rb"].each do |file|
          get_items_of get_controller(dir, file)
        end
      end
    end
    private
    def collect_paths
      paths = []
      @items.each do |item|
        path = item.path
        loop do
          break if path.empty?
          break if paths.include? path
          paths << path
          path = path.split('/')[0..-2].join('/')
        end
      end
      paths
    end
    def get_i18n_content content
      begin
        content.singularize.constantize.model_name.human(count: 2)
        return "'#{content}'.singularize.constantize.model_name.human(count: 2)"
      rescue I18n::InvalidPluralizationData
        content.singularize.constantize.model_name.human(count: 1)
        return "'#{content}'.singularize.constantize.model_name.human(count: 1)"
      rescue NameError
        return content
      end
    end
    def fill_gaps
      collect_paths.each do |path|
        next unless get(path).nil?
        item = Item.new
        item.path       = path
        item.type       = Decorator.at level: item.level
        item.constraint = Constraint.default
        item.content    = "#{File.basename(path)}"
        item.content    = get_i18n_content item.content
        begin
          item.active_controller = "#{item.content}Controller".constantize
          item.active_on         = :all
        rescue NameError
          nil
        end
        item.save
      end
    end
  end
end