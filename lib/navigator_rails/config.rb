module NavigatorRails
  module Config
    def config &block
      if block_given?
        @config ||= {
          default_constraint: true,
          use_cancan: false,
          use_devise: false,
          use_rolify: false,
           search_at: %w{ app/controllers },
         controllers: [],
          decorators: [ :navigator, :navbar, :submenu, :link ],
        }
        class_eval(&block)
        Decorator.instance
        Store.instance
        Store.collect
        Store.process_config_builders
      else
        @config
      end
    end
    def brand params={}
      params[:path]    and path    = "/#{params[:path].to_s}/brand"
      params[:content] and content = params[:content]
      path    ||= '/head'
      content ||= '<span class="ion-cube">Project Name</span>'

      @config[:build_brand] = {path: path, content: content}
    end
    def use *params
      if params.count == 1 and params.first.class == Hash
        features = params.first.keys
        params.first.each do |builder,path|
          @config["build_#{builder}_at".to_sym] = path
        end
      else
        features = params
      end
      features.each do |feature|
        @config["use_#{feature}".to_sym] = true
      end
    end
    def constraint constraint
      @config[:default_constraint] = constraint
    end
    def cancan?
      defined?(CanCan) and true
    end
    def devise?
      defined?(Devise) and true
    end
    def rolify?
      defined?(Rolify) and true
    end
    def rails?
      defined?(Rails) and true
    end
  end
end