class App
  module Views
    class Hello < Mustache
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
    end
  end
end
