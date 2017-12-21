class Exchange
    attr_accessor :price_board
    attr_accessor :order_book

    def initialize()
        @price_board = {}
        @order_book = []
    end
end