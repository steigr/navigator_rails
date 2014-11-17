module NavigatorRails
  module Decorators
    class Brand
      include NavigatorRails::Decorators::Generic
      def template
        <<-LINK_DECORATION.strip_heredoc
          <%= resource.content %>
        LINK_DECORATION
      end
    end
  end
end