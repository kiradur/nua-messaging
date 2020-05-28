class UpdateAllMessagesReadStatus < ActiveRecord::Migration[5.0]
  def up
    Message.update_all(read: true)
  end
end
