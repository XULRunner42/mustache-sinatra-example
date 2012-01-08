class App
  module Views
    class Amazon < Document
      def self.body
        sess = login_amazon
        orders_page=visit_unshipped(sess)

        html_doc=Nokogiri::HTML(orders_page.body)
        content=html_doc.css("table.data-display")
      end
      def self.login_amazon
        sess=Patron::Session.new
        response=visit_amazon(sess)
        html_doc=Nokogiri::HTML(response.body)
        form=html_doc.css("form")
        param=build_login(form)
        login=sess.post "/gp/sign-in/sign-in.html/ref=ag_login_lgin_home", param
        #html_doc=Nokogiri::HTML(login.body)
        sess
      end
      def self.visit_amazon(sess)
        sess.timeout=20
        sess.handle_cookies("cookies.txt")
        sess.base_url="http://sellercentral.amazon.com/"
        response=sess.get "/gp/homepage.html"
      end

      # unshipped, neworders
      # methods to request an order report is generated.
      # what happens if you call them too often?
      def unshipped(sess)
        sess.post("/gp/upload-download-utils/requestReport.html",
          QueryParams.encode({ "type" => "UnshippedOrders" }))
      end
      def neworders(sess)
        sess.post("/gp/upload-download-utils/requestReport.html",
          QueryParams.encode({ "type" => "Orders", "days" => "30" }))
      end
      def order_pickup(sess)
        sess.get("/gp/transactions/orderPickup.html").body
      end
      def self.visit_unshipped(sess)
        sess.get "/gp/orders-v2/list/ref=ag_myo_doa1_home?ie=UTF8&searchType=OrderStatus&ignoreSearchType=1&statusFilter=ItemsToShip&searchFulfillers=mfn&preSelectedRange=37&searchDateOption=preSelected&sortBy=OrderStatusDescending"
      end


      def self.build_login(form)
        sessid=pluck("session-id", form)
        protocol=pluck("protocol", form)
        action=pluck("action", form)
        email="kingdon@tuesdaystudios.com"
        destination=pluck("destination", form)
        optin=pluck("optin", form)
        ouid=pluck("ouid", form)

        data={ "session-id" => sessid, "protocol" => protocol, "action" => action, 
          "email" => email, "destination" => destination, "optin" => optin,
          "ouid" => ouid, "password" => File.new("pass","r").gets }
        param=QueryParams.encode(data)
      end
    end
  end
end
