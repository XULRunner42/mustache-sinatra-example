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
      html_doc = Nokogiri::HTML(File.new("#{$FOO}/out/payment.html",'r'))
    end
  end
  def orders_vs_payments
    parse_orders = orders.resume
    parse_payments = payments.resume
# Now what?
    [parse_orders, parse_payments]
    #puts parse_orders
    #puts parse_payments
  end
end
