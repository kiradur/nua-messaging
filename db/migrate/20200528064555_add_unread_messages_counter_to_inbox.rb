class AddUnreadMessagesCounterToInbox < ActiveRecord::Migration[5.0]
  def change
    add_column :inboxes, :unread_messages, :integer, dafault: 0
  end
end
