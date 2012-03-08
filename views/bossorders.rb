
#      def self.visit_orders(sess)
#        sess.get "/order_list.php"
#      end
#      def self.visit_orders_2(sess)
#        sess.get "/order_list.php?order_by=so.so_date&order_dir=DESC&txtFromDate=10%2F08%2F2011&txtToDate=01%2F08%2F2012&page=2"
#      end
# Resources
class App
  module Views
    class Bossorders < Bossservice
      def self.visit_orders(sess)
	sess.get "/order_list.php?txtSoNo=&txtPoNo=&cmbType=&cmbStatus=&txtFromDate=01%2F01%2F2011&txtToDate=03%2F08%2F2012&order_by=so.so_date&order_dir=DESC&page=1"
      end
      def self.visit_orders_2(sess)
	sess.get "/order_list.php?txtSoNo=&txtPoNo=&cmbType=&cmbStatus=&txtFromDate=01%2F01%2F2011&txtToDate=03%2F08%2F2012&order_by=so.so_date&order_dir=DESC&page=2"
      end
      def self.visit_orders_3(sess)
	sess.get "/order_list.php?txtSoNo=&txtPoNo=&cmbType=&cmbStatus=&txtFromDate=01%2F01%2F2011&txtToDate=03%2F08%2F2012&order_by=so.so_date&order_dir=DESC&page=3"
      end
      def self.body
        sess = login_boss
        orders_page=visit_orders(sess)
        orders_page_2=visit_orders_2(sess)
	orders_page_3=visit_orders_3(sess)

        html_doc=Nokogiri::HTML(orders_page.body)
        content=html_doc.css("table")
        dropbox=html_doc.css("div.pagination").first
        main=footer sess
    forms=[]
    main.each do|form|
      orderinfo=form.xpath("fieldset")[0]
      items=form.xpath("fieldset")[1]
      comments=form.xpath("fieldset")[2]
      data={"orderinfo"=>orderinfo, "items"=>items, "comments"=>comments}
      forms << data
    end
    orders={ "table"=>content, "pagination"=>dropbox, "content"=>forms }
     #   dir
      end
      def self.footer(sess)
        orders_page=visit_orders(sess)
        orders_page_2=visit_orders_2(sess)
	orders_page_3=visit_orders_3(sess)
        html_doc=Nokogiri::HTML(orders_page.body)
        html_doc_2=Nokogiri::HTML(orders_page_2.body)
	html_doc_3=Nokogiri::HTML(orders_page_3.body)

        content=html_doc.css("div#main-body")
        content_2=html_doc_2.css("div#main-body")
	content_3=html_doc_3.css("div#main-body")
        dir=[]
        links('View',content).each do|link|
          htm=Nokogiri::HTML(visit_order_view(sess,link).body)
          track=htm.css("form")
          dir << track
        end
        links('View',content_2).each do|link|
          htm=Nokogiri::HTML(visit_order_view(sess,link).body)
          track=htm.css("form")
          dir << track
        end
        dir
      end
      def self.visit_order_view(sess, link)
        sess.get "#{link}"        
      end
      def visit_order_tracking(sess, link)
        sess.get "#{link}"
      end
    end
  end
end

