class CreateCoinbaseTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :coinbase_trades do |t|
      t.string :userEmail
      t.string :timestamp
      t.string :transactionType
      t.string :asset
      t.string :quantityTransacted
      t.string :eurSpotPrice
      t.string :eurSubtotal
      t.string :eurTotal
      t.string :eurFees
      t.string :notes

      t.timestamps
    end
  end
end
