class Order
    attr_accessor :id
    attr_accessor :mkt
    attr_accessor :volume
    attr_accessor :price
    attr_accessor :value
    attr_accessor :side
    attr_accessor :status
    attr_accessor :timestamp

    def initialize(id, mkt, volume, price, value, side, status,timestamp)
        @id = id
        @mkt = mkt
        @volume = volume
        @price = price
        @value = value
        @side = side
        @status = status
        @timestamp = timestamp
    end
end