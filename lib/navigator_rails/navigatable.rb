module NavigatorRails
  module Navigatable
    extend ActiveSupport::Concern
    included do
      class_attribute :navigator_rails_items
      hide_action :navigator_rails_items
      hide_action :navigator_rails_items=
      hide_action :navigator_rails_items?
      hide_action :navigator
    end
    module ClassMethods
      def menu_item params={}
        self.navigator_rails_items ||= []
        self.navigator_rails_items  << Item.new(params.merge(active_controller: self))
      end
      def scaffold_menu path='/head/left'
        submenu_path = self.to_s.sub(/Controller$/,'')
        self.navigator_rails_items ||= []
        methods = []
        methods << 'index'   if self.action_methods.include? 'index'
        methods << 'new'     if self.action_methods.include? 'new'
        methods << 'show'    if self.action_methods.include? 'show'
        methods << 'edit'    if self.action_methods.include? 'edit'
        methods << 'destroy' if self.action_methods.include? 'destroy'
        methods += (self.action_methods.to_a - methods)

        methods.each do |action|
          params = {}
          params[:constraint] = NavigatorRails.config[:default_constraint].to_s
          params[:constraint] += ' and user_signed_in? ' if NavigatorRails.config[:use_devise]
          case action.to_sym
          when :create, :update
            next
          when :index
            path_helper_string  = "#{submenu_path}Url".underscore
            label = action
          when :destroy
            params[:constraint] += " and @#{submenu_path.singularize.underscore} != nil"
            path_helper_string  = "@#{submenu_path.singularize}, method: :delete".underscore
            label = "#{action} \#{@#{submenu_path.singularize.underscore}.to_s}"
          when :show
            params[:constraint] += " and @#{submenu_path.singularize.underscore} != nil"
            path_helper_string  = "@#{submenu_path.singularize}".underscore
            label = "#{action} \#{@#{submenu_path.singularize.underscore}.to_s}"
          when :edit
            params[:constraint] += " and @#{submenu_path.singularize.underscore} != nil"
            path_helper_string  = "#{action.classify}#{submenu_path.singularize}Url(@#{submenu_path.singularize})".underscore
            label = "#{action} \#{@#{submenu_path.singularize.underscore}.to_s}"
          else
            path_helper_string  = "#{action.classify}#{submenu_path.singularize}Url".underscore
            label = action
          end
          params[:path]       = "#{path}/#{submenu_path}/#{action}"
          params[:content]    = "link_to(\"#{label}\",#{path_helper_string})"
          self.navigator_rails_items  << Item.new(params)
        end
      end
    end
  end
end