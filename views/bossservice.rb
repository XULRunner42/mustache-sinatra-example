class App
  module Views
    class Bossservice < Document
      def self.links(str,elem)
        elem.xpath("//td/a[@title='#{str}']/@href")
      end
      def self.login_boss
        sess=Patron::Session.new
        sess.timeout=60
        response=visit_boss(sess)
        html_doc=Nokogiri::HTML(response.body)
        form=html_doc.css("form")
        param=build_login(form)
        login=sess.post "/home.php", param
        sess
      end
      def self.visit_boss(sess)
        sess.handle_cookies("cookies.txt")
        sess.base_url="https://www.bossservice.com/"
        response=sess.get "/index.php"
        response
      end
      def self.build_login(form)
        txtUserName="eb620"
        txtPassword=File.new("pass.eb620","r").gets
        btnLogin=pluck("btnLogin", form)

        data={ "txtUserName" => txtUserName, "txtPassword" => txtPassword,
          "btnLogin" => btnLogin }
        param=QueryParams.encode(data)
        param
      end
    end
  end
end
