class App
  module Views
    class Bosspayment < Bossservice
      def self.links(str,elem)
        elem.xpath("//td/a[@title='#{str}']/@href")
      end
      def self.body
        sess = login_boss
        payment_page=visit_payment_history(sess)

        html_doc=Nokogiri::HTML(payment_page.body)
        content=html_doc.css("div#main-body")
        dir=[]
        links('View',content).each do|link|
          htm=Nokogiri::HTML(visit_payment_link(sess,link).body)
          pay=htm.css("form")
          dir << {"pay"=>pay}
        end
        dir
      end
      def self.visit_payment_history(sess)
        sess.get "/payment_list.php"
      end
      def self.visit_payment_link(sess, link)
        sess.get "#{link}"
      end
    end
  end
end

