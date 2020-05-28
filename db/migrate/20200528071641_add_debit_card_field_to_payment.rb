class AddDebitCardFieldToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :debit_card_last_four_digits, :string
  end
end
