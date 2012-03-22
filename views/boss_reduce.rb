require 'yaml'
require 'ap'

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
          sono = node.xpath("./div[@id='lblSoNo']").text.chomp
          detail = node.xpath(".//table")
          #pono = node.xpath("./div[@id='lblPoNo']").text
          unless sono.length==0
            s += "---\nsono: #{sono.ljust(10)}\n"
          #  s += "pono: #{pono}</pre>\n"
          end
          n=0
          unless detail.text.length==0
            line=detail.xpath(".//tr")
            line.each do|row|
            n+=1
              model=row.xpath(".//td").first
              s += "detail#{n}: #{model.text}\n" unless model.nil? or model.text == "\u00A0"
            end
          end
        end
        
        #puts s
        YAML.load_documents(s)
      end
      def self.payments
[
  ['6123342', '$278.55'],
['6125549', '$135.25'],
['6125558', '$160.42'],
['6122073', '$154.26'],
['6122275', '$47.25'],
['6122275', '$78.00'],
['6121363', '$458.19'],
['6122068', '$148.49'],
['6122108', '$160.97'],
['6122123', '$145.05'],
['6121753', '$148.49'],
['6121954', '$148.49'],
['6122003', '$148.49'],
['6122045', '$87.12'],
['6122055', '$66.00'],
['6122078', '$87.12'],
['6122110', '$87.12'],
['6122114', '$81.00'],
['6122100', '$109.22'],
['6124990', '$38.41'],
['6124994', '$556.01'],
['6122819', '$445.44'],
['6121874', '$160.97'],
['6121019', '$945.63'],
['6121358', '$74.91'],
['6121361', '$77.25'],
['6121724', '$148.49'],
['6121731', '$168.20'],
['6121357', '$81.00'],
['6121359', '$30.50'],
['6121360', '$31.63'],
['6121364', '$29.94'],
['6121330', '$77.25'],
['6120998', '$51.28'],
['6114345', '$116.10'],
['6114349', '$343.94'],
['6114449', '$34.00'],
['6114353', '$86.16'],
['6114342', '$88.90'],
['6114347', '$55.39'],
['6108919', '$47.72'],
['6092680', '$0.90'],
['6092680', '$338.06'],
['6092370', '$145.58'],
['6092029', '$64.39'],
['6089141', '$85.40'],
['6086480', '$64.39'],
['6085608', '$183.75'],
['6083530', '$88.13'],
['6082012', '$42.51'],
['6078098', '$42.50'],
['6075001', '$41.27'],
['6074192', '$77.25'] ]
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
        a = payments
        s = "\n<pre>available inventory count: #{i}</pre>"
        b = group_orders
        s += "\n<pre>"
        a.map! do |pymt|
          b.each do |block|
            pymt << block if block["sono"].to_s==pymt[0]
          end
          pymt
        end
        s += "</pre>"
        #s+=a.to_s
        ap a

        s+="\nthis is <a href='/document/boss/reduce'>the body</a> of the page"
        {"body"=>s}
      end
    end
  end
end
