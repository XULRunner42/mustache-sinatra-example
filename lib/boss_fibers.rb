require 'nokogiri'
require 'ap'

$FOO = "/home/yebyen/Desktop/ergoback"
class BossFibers
  def inventory
    Fiber.new do
      @inventory = Nokogiri::HTML(File.new("#{$FOO}/INVENTORY.html",'r'))
      while true do 
	Fiber.yield [
        @inventory.xpath("//tr/td[1]"),
        @inventory.xpath("//tr/td[2]"),
        @inventory.xpath("//tr/td[3]"),
        @inventory.xpath("//tr/td[4]")
        ].map(&:pop)
      end
    end
  end
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
