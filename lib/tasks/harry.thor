
# bundle exec thor list
class Harry < Thor
  desc "method_name", "a method name describes a thor task"
  def method_name
    puts "i have no options or parameters"
  end

  desc "name_method", "a thor guy implements a method name"
  def name_method
    puts "your job is to sell chairs on Amazon"
  end

  desc "cross_reference", "make use of orders_vs_payments"
  def cross_reference
    require './lib/boss_fibers'
    arr = BossFibers.new.orders_vs_payments
    p arr
  end
end
