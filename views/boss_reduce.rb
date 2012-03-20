class App
  module Views
    class BossReduce < Document
      def self.body
        require './lib/boss_fibers.rb'
        s=""
        b=BossFibers.new
        f=b.inventory
        inv=f.resume
        inv=f.resume
        inv=f.resume
        inv.each do|item|
          s+="\n<pre>#{item.children}</pre>"
        end

        s+="\nthis is <a href='/document/boss/reduce'>the body</a> of the page"
        {"body"=>s}
      end
    end
  end
end
