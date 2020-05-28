class Message < ApplicationRecord

  belongs_to :inbox
  belongs_to :outbox

end