class Message < ApplicationRecord

  belongs_to :inbox
  belongs_to :outbox

  def receiver_inbox
    is_old_message? ? Inbox.default_admin_inbox : author.inbox
  end

  private
  def author
    outbox.user
  end

  def is_old_message?
    created_at.in_time_zone < DateTimeHelper.one_week_ago
  end

end
