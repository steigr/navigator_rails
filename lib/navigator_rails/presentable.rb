module NavigatorRails
  module Presentable
    extend ActiveSupport::Concern
    included do
      cattr_accessor :navigation_label
    end
    module ClassMethods
      def resource_menu_label key
        self.navigation_label = key
      end
    end
  end
end