
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
	order_pages = []

	[1,2,3].each do|page|
	  ok = false
	  while !ok do
	    begin
	      order_pages << sess.get("/order_list.php?txtSoNo=&txtPoNo=&cmbType=&cmbStatus=&txtFromDate=01%2F01%2F2011&txtToDate=03%2F08%2F2012&order_by=so.so_date&order_dir=DESC&page=#{page}")
	    rescue
	      # try again
	    else
	      ok = true
	    end
	  end
	end
	order_pages
      end
      def self.body
        sess = login_boss
        order_pages = visit_orders(sess)

	#[1 2 3].each do|page|
        #html_doc=Nokogiri::HTML(order_pages[page].body)
        html_doc = Nokogiri::HTML(order_pages[0].body)
        content = html_doc.css("table")
        dropbox = html_doc.css("div.pagination").first
        main = footer sess
    forms = []
    main.each do|form|
      orderinfo = form.xpath("fieldset")[0]
      items = form.xpath("fieldset")[1]
      comments = form.xpath("fieldset")[2]
      data = {"orderinfo"=>orderinfo, "items"=>items, "comments"=>comments}
      forms << data
    end
    orders = {"table"=>content, "pagination"=>dropbox, "content"=>forms}
     #   dir
      end
      def self.footer(sess)
        order_pages = visit_orders(sess)
	html_doc = []
        html_doc[0] = Nokogiri::HTML(order_pages[0].body)
        html_doc[1] = Nokogiri::HTML(order_pages[1].body)
	html_doc[2] = Nokogiri::HTML(order_pages[2].body)

	content = []
        content[0] = html_doc[0].css("div#main-body")
        content[1] = html_doc[1].css("div#main-body")
	content[2] = html_doc[2].css("div#main-body")

        dir = []
        links('View', content[0]).each do|link|
          htm = Nokogiri::HTML(visit_order_view(sess,link).body)
          track = htm.css("form")
          dir << track
        end
        links('View', content[1]).each do|link|
          htm = Nokogiri::HTML(visit_order_view(sess,link).body)
          track = htm.css("form")
          dir << track
        end
        links('View', content[2]).each do|link|
          htm = Nokogiri::HTML(visit_order_view(sess,link).body)
          track = htm.css("form")
          dir << track
        end
        dir
      end
      def self.visit_order_view(sess, link)
	ok = false
	order = nil
	while !ok do
	  begin
	    order = sess.get "#{link}"        
	  rescue
	    # try again
	  else
	    ok = true
	  end
	end
	order
      end
      def visit_order_tracking(sess, link)
	ok = false
	tracking = nil
	while !ok do
	  begin
	    sess.get "#{link}"
	  rescue
	    # try again
	  else
	    ok = true
	  end
	end
	tracking
      end
    end
  end
end

