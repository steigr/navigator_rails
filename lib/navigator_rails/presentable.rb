module NavigatorRails
  module Presentable
    extend ActiveSupport::Concern
    included do
      cattr_accessor :resource_menu_label
    end
    module ClassMethods
      def resource_menu_label key=nil
      end
    end
  end
end