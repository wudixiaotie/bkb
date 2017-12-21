class Account
  attr_accessor :usdt
  attr_accessor :mkts

  def initialize(usdt, mkt_arr)
    @usdt = usdt

    @mkts = {}
    mkt_arr.each do |mkt|
      @mkts[mkt.to_sym] = 0.0
    end
  end
end