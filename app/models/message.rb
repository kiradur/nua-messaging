class Message < ApplicationRecord

  belongs_to :inbox
  belongs_to :outbox

  after_create :increment_inbox_unread_messages_counter

  def receiver_inbox
    is_old_message? ? Inbox.default_admin_inbox : author.inbox
  end

  def mark_as_read
    unless read
      update(read: true)
      decrement_inbox_unread_messages_counter
    end
  end

  private

  def author
    outbox.user
  end

  def is_old_message?
    created_at.in_time_zone < DateTimeHelper.one_week_ago
  end

  def increment_inbox_unread_messages_counter
    inbox.increment!(:unread_messages)
  end

  def decrement_inbox_unread_messages_counter
    inbox.decrement!(:unread_messages) if inbox.unread_messages >= 0
  end

end
