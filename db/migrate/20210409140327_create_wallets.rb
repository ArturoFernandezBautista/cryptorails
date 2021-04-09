class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets do |t|
      t.string :userEmail
      t.string :asset
      t.string :amount

      t.timestamps
    end
  end
end
