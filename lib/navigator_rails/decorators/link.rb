module NavigatorRails
  module Decorators
    class Link
      include NavigatorRails::Decorators::Generic
      def template
        <<-LINK_DECORATION.strip_heredoc
          <li><%= resource.content %></li>
        LINK_DECORATION
      end
    end
  end
end