class BossFibers
  def orders
    Fiber.new do
      get_order
    end
  end
  def payments
    Fiber.new do
      get_payment
    end
  end
  def orders_vs_payments
  end
end
