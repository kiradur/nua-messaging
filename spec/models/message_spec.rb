require 'rails_helper'
require_relative '../support/users_helper.rb'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe Message, type: :model do
  before :each do
    create_users
    @message = Message.create(body: 'New message', inbox: @doctor.inbox, outbox: @patient.outbox)
  end

  it 'creates new message' do
    expect(Message.last).to eql(@message)
  end

  it 'has status unred' do
    expect(Message.last.read).to eql(false)
  end

  it 'is sent to corrent inbox' do
    expect(Message.last.inbox).to eql(@doctor.inbox)
  end

  it 'is sent to corrent outbox' do
    expect(Message.last.outbox).to eql(@patient.outbox)
  end

  it 'increments doctors new messages in inbox' do
    expect(@doctor.inbox.new_messages).to eql(1)
  end

  it 'decrements doctors new messages in inbox after the message is read' do
    @message.update(read: true)
    expect(@doctor.inbox.new_messages).to eql(0)
  end
end
