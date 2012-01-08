class App
  module Views
    class Bossorders < Bossservice
      def self.body
        sess = login_boss
        orders_page=visit_orders(sess)

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
        html_doc=Nokogiri::HTML(orders_page.body)

        content=html_doc.css("div#main-body")
        dir=[]
        links('View',content).each do|link|
          htm=Nokogiri::HTML(visit_order_view(sess,link).body)
          track=htm.css("form")
          dir << track
        end
        dir
      end
      def self.visit_orders(sess)
        sess.get "/order_list.php"
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

