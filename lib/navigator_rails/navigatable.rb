module NavigatorRails
  module Navigatable
    extend ActiveSupport::Concern
    included do
      class_attribute :navigator_rails_items
    end
    module ClassMethods
      def menu_item params={}
        self.navigator_rails_items ||= []
        self.navigator_rails_items  << Item.new(params.merge(active_controller: self))
      end
    end
  end
end