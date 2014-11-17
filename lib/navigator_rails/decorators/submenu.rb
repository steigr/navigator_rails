module NavigatorRails
  module Decorators
    class Submenu
      include NavigatorRails::Decorators::Generic
      def template
        return '' unless has_visible_children
        <<-LINK_DECORATION.strip_heredoc
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%= resource.content %> <span class="caret"></span></a>
            <ul class="dropdown-menu" role="menu">
              <%= children %>
            </ul>
          </li>
        LINK_DECORATION
      end
    end
  end
end