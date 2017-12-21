require 'time'
require 'pathname'
path = Pathname.new(File.dirname(__FILE__)).realpath
require "#{path}/account.rb"
require "#{path}/exchange.rb"
require "#{path}/order.rb"
require "#{path}/tick.rb"

class BKB
  attr_reader :account
  attr_reader :exchange

  def initialize(usdt, mkt_arr, begin_date, end_date)
    @account = Account.new(usdt, mkt_arr)
    @begin = begin_date
    @end = end_date
    @exchange = Exchange.new
  end

  def run
    begin_timestamp = Time.parse(@begin).to_i
    end_timestamp = Time.parse(@end).to_i
    today = begin_timestamp
    while today <= end_timestamp
      p "get data on #{Time.at(today).to_s}"

      tick_arr = []
      now = today
      for i in 0..1440
        now += i * 60
        tick = Tick.new(now)
        @account.mkts.keys.each do |mkt|
          tdata = TData.new(rand(100000..10000000) * 0.001, i * 100)
          tick.mkts[mkt] = tdata
          @exchange.price_board[mkt] = tdata.latest
        end
        tick_arr.push(tick)
      end
      tick_arr.each_with_index {|tick,index| handle_tick(tick,today + (index + 1) * 60)}

      last_tick = tick_arr.last
      assets_value = @account.usdt
      last_tick.mkts.each do |mkt, tdata|
        assets_value += @account.mkts[mkt] * tdata.latest
      end
      p "#{Time.at(today).strftime('%F %T')} assets_value: #{assets_value} available:#{@account.usdt}"

      today += 86400
    end
  end

  def place_order(mkt, value, price, side, today)
    latest = @exchange.price_board[mkt]
    volume = (value / price.to_f).round(6)
    order = Order.new(@exchange.order_book.length, mkt, volume, price, value, side, :sucess, Time.at(today).to_s)
    if side == :ask
      if @account.mkts[mkt] >= volume
        @account.usdt += value
        @account.mkts[mkt] -= volume
        @exchange.order_book.push(order)
      else
        # p "[warning][RiskControl] The #{mkt} in your account is not enough"
      end
    else
      if @account.usdt >= value
        @account.usdt -= value
        @account.mkts[mkt] += volume
        @exchange.order_book.push(order)
      else
        # p "[warning][RiskControl] The usdt in your account is not enough"
      end
    end
  end

  def orders
    @exchange.order_book
  end

  def ask_orders
    @exchange.order_book.map {|x| x if x.side == :ask}
  end

  def bid_orders
    @exchange.order_book.map {|x| x if x.side == :bid}
  end

  def balances
    balance = @account
    string = ''
    string << "USDT: #{@account.usdt}"
    @account.mkts.keys.each do |mkt|
      string << " #{mkt}: #{@account.mkts[mkt]}"
    end
    string
  end
end