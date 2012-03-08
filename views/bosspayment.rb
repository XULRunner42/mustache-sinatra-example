
# https://www.bossservice.com/payment_list.php?txtPaymentNo=&txtFromDate=01%2F01%2F2011&txtToDate=03%2F08%2F2012&order_by=p.payment_time&order_dir=DESC&page=2
# Resources
class App
  module Views
    class Bosspayment < Bossservice
      def self.body
        sess = login_boss
        payment_page=visit_payment_history(sess)

        html_doc=Nokogiri::HTML(payment_page.body)
        content=html_doc.css("div#main-body")
        dir=[]
        links('View',content).each do|link|
          htm=Nokogiri::HTML(visit_payment_link(sess,link).body)
          pay=htm.css("form")
          dir << pay
        end
        dir
      end
      def self.visit_payment_history(sess)
        sess.get "/payment_list.php?txtPaymentNo=&txtFromDate=01%2F01%2F2011&txtToDate=03%2F08%2F2012&order_by=p.payment_time&order_dir=DESC&page=1"
      end
      def self.visit_payment_link(sess, link)
        sess.get "#{link}"
      end
    end
  end
end

