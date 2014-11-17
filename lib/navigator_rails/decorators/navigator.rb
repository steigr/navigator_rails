module NavigatorRails
  module Decorators
    class Navigator
      include NavigatorRails::Decorators::Generic
      def brand
        brand = Store.children_of(resource).select{|x|x.type==:brand}.first
        brand.decorator.draw(brand).html_safe
      end
      def template
        <<-LINK_DECORATION.strip_heredoc
          <div class="navbar navbar-default navbar-fixed-top">
            <div class="container">
              <div class="navbar-header">
                <button type="button" data-toggle="collapse" data-target=".navbar-collapse" class="navbar-toggle">
                  <span class="sr-only">Toggle navigation</span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                </button>
                <%= brand %>
              </div>
            <div class="collapse navbar-collapse">
              <%= children except: :brand %>
            </div>
          </div>
        </div>
        LINK_DECORATION
      end
    end
  end
end