module NavigatorRails
  module Decorators
    class Navbar
      include NavigatorRails::Decorators::Generic
      def template
        return '' unless has_visible_children
        <<-LINK_DECORATION.strip_heredoc
          <ul class="nav navbar-nav navbar-<%= resource.relative_path %>">
            <%= draw_children %>
          </ul>
        LINK_DECORATION
      end
    end
  end
end