module NavigatorRails
  module Builder
    def navigator_builder
      def path       param; @i.send("#{__method__}=",param);      end
      def order      param; @i.send("#{__method__}=",param);      end
      def content    param; @i.send("#{__method__}=",param.call); end
      def constraint param; @i.send("#{__method__}=",param);      end
      def decorator  param; @i.send("#{__method__}=",param);      end
      def type       param; @i.send("#{__method__}=",param);      end
      @i = Item.new
      yield
      @i.save
    end
  end
end

