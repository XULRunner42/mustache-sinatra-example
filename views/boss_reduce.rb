class App
  module Views
    class BossReduce < Document
      def self.count_inventory
        require './lib/boss_fibers'
        s = ""
        b = BossFibers.new
        f = b.inventory
        inv = f.resume  # throw away one for the header
        a = []
        inventory = 0
        while inv = f.resume
          i_0=inv[0].text.ljust(12)
          i_1=inv[1].text
          i_2=inv[2].text.to_i
          i_3=inv[3].text.to_i
          a<<[i_0, i_2+i_3]
          #i="<pre>#{i_0}  #{i_1}  #{i_2}  #{i_3}</pre>" #.gsub!(/\n +/,"")
          #i="<pre>#{i_0}    #{i_2+i_3}</pre>" #.gsub!(/\n +/,"")
          #i.gsub!(/^ +/, "")
          #i.gsub!(/\n/, "")
          inventory = a.reduce(0) do |sum, arr|
            sum + arr[1]
          end
        end
        inventory
      end
      def self.group_orders
        require './lib/boss_fibers'
        s = ""
        b = BossFibers.new
        f = b.orders

        h = f.resume

        h.xpath("//fieldset").each do|node|
          sono = node.xpath("./div[@id='lblSoNo']").text
          detail = node.xpath(".//table")
          #pono = node.xpath("./div[@id='lblPoNo']").text
          unless sono.length==0
            s += "<pre>sono: #{sono.ljust(10)}"
          #  s += "pono: #{pono}</pre>\n"
          end
          unless detail.text.length==0
            line=detail.xpath(".//tr")
            line.each do|row|
              model=row.xpath(".//td").first
              s += "detail: #{model.text}\n" unless model.nil? or model.text == "\u00A0"
            end
            s += "</pre>"
          end
        end
        
        s
      end
      def self.ungroup_payments
        require './lib/boss_fibers'
        s = ""
        b = BossFibers.new
        f = b.payments

        h = f.resume

        h.xpath("//table").each do |node|
          data = []
          payment_data = node.children[1]
          payment_data.children.each do|payment|
            cells = payment.xpath(".//td")
            data << [cells.first.to_s, cells.last.to_s]
          end
          data.each do|text|
            s += "<pre>#{text}</pre>"
          end
          #s += "<pre>#{payment_data.children[1].text}</pre>"
          #s += "<pre>#{node.text}</pre>"
        end

        s
      end
      def self.body
        i = count_inventory
        s = "\n<pre>available inventory count: #{i}</pre>"
        a = group_orders
        s += "\n#{a}"
        a = ungroup_payments
        s += "\n#{a}"

        s+="\nthis is <a href='/document/boss/reduce'>the body</a> of the page"
        {"body"=>s}
      end
    end
  end
end
