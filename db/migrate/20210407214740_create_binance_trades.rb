class CreateBinanceTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :binance_trades do |t|
      t.string :userEmail
      t.string :date
      t.string :market
      t.string :tradeType
      t.string :price
      t.string :amount
      t.string :total
      t.string :fee
      t.string :feeCoin

      t.timestamps
    end
  end
end
