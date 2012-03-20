class App
  module Views
    class BossReduce < Document
      def self.body
        require './lib/boss_fibers.rb'
        s = ""
        b = BossFibers.new
        f = b.inventory
        inv = f.resume  # throw away one for the header
        while inv = f.resume
          i_0=inv[0].text
          i_1=inv[1].text
          i_2=inv[2].text
          i_3=inv[3].text
          i="<pre>#{i_0}  #{i_1}  #{i_2}  #{i_3}</pre>" #.gsub!(/\n +/,"")
          i.gsub!(/^ +/, "")
          i.gsub!(/\n/, "")
          s += "\n#{i}"
        end

        s+="\nthis is <a href='/document/boss/reduce'>the body</a> of the page"
        {"body"=>s}
      end
    end
  end
end
