require 'nokogiri'
require 'ap'

$FOO = "/home/yebyen/Desktop/ergoback"
class BossFibers
  def orders
    Fiber.new do
      html_doc = Nokogiri::HTML(File.new("#{$FOO}/out/orders.html",'r'))
    end
  end
  def payments
    Fiber.new do
      get_payment
    end
  end
  def orders_vs_payments
    nok = orders.resume
    ap nok
  end
end
