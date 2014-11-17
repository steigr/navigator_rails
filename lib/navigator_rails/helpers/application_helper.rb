module NavigatorRails
  module Helpers
    module ApplicationHelper
      def self.included(base)
        base.class_eval do
          require 'navigator_rails/navigator'
          helper_method :navigator
          def navigator
            @navigator = NavigatorRails::Navigator
          end
        end
      end
    end
  end
end