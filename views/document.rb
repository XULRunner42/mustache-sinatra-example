class App
  module Views
    class Document < Mustache
      @@have=nil
      def self.have(got)
        @@have=got
      end
      def have
        !@@have.nil?
      end
      def got
        @@have
      end
      def self.pluck(str,elem)
        elem.xpath("//input[@name='#{str}']/@value").first.value
      end
    end
  end
end
