require 'pathname'
path = Pathname.new(File.dirname(__FILE__)).realpath
require "#{path}/bkb.rb"

class Test < BKB
  def handle_tick(tick,today)
    tdata = tick.mkts[:BTC]
    if tdata.latest > 9000
      place_order(:BTC, 50, tdata.latest, :ask, today)
    else
      place_order(:BTC, 50, tdata.latest, :bid, today)
    end
  end
end

t = Test.new(100000000, [:BTC, :ETH], '2017-01-01', '2017-12-30')
start_time = Time.now
t.run
puts ''
puts '=' * 50
puts '|| 卖单统计: ' + "#{t.ask_orders.compact.count}"
puts '|| 买单统计: ' + "#{t.bid_orders.compact.count}"
puts '|| 账户余额: ' + "#{t.balances}"
puts '|| 回测耗时: ' + "#{Time.now - start_time}"
puts '=' * 50