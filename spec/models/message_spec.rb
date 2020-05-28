require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:patient) { create :user, :patient }
  let(:doctor) { create :user, :doctor }

  let(:message) { build :message, {
    inbox: doctor.inbox,
    outbox: patient.outbox }
  }

  context 'Unread Message' do
    it 'triggers inbox unread messages callback' do
      expect(message).to receive(:increment_inbox_unread_messages_counter)
      message.save
    end

    it 'increment inbox unread message counter' do
      expect{ message.save }.to change { doctor.inbox.reload.unread_messages }.from(0).to(1)
    end
  end

  context 'Read Message' do
    it 'updates read status to true' do
      message.save
      expect{ message.send(:mark_as_read) }.to change { message.reload.read }.from(false).to(true)
    end

    it 'decrements inbox unread message counter' do
      message.save
      expect{ message.mark_as_read }.to change { doctor.inbox.reload.unread_messages }.from(1).to(0)
    end
  end
end
