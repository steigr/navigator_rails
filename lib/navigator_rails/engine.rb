require 'navigator_rails/config'
require 'navigator_rails/navigatable'
require 'navigator_rails/presentable'
require 'navigator_rails/contextable'
require 'navigator_rails/store'
require 'navigator_rails/helpers'
require 'navigator_rails/builder'
require 'navigator_rails/constraint'
require 'navigator_rails/item'
require 'navigator_rails/decorator'
require 'navigator_rails/decorators'

module NavigatorRails
  class Engine < ::Rails::Engine
    initializer 'navigator_rails.add_navigator' do
      config.to_prepare do
        ApplicationController.send(:include,Helpers::ApplicationHelper)
        Store.collect
      end
    end
  end
  class << self
    include Config
  end
end
