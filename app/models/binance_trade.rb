class BinanceTrade < ApplicationRecord
	validates_presence_of :userEmail, :date, :market, :tradeType, :price, :amount, :total, :fee, :feeCoin
end
