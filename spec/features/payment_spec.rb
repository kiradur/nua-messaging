require 'rails_helper'
require_relative '../support/users_helper.rb'

RSpec.configure do |c|
  c.include UserHelpers
end

feature 'Inbox' do
  describe 'As a doctor' do
    before :each do
      create_users
      @message = Message.create(body: 'New message', inbox: @doctor.inbox, outbox: @patient.outbox)
      visit message_path(@message)
      expect(page).to have_content("I've lost my script, please issue a new one at a charge of €10")
      click_on "I've lost my script, please issue a new one at a charge of €10"
    end

    it 'lost script message has been sent to admin' do
      expect(@admin.inbox.messages.last.body).to eql("New request for lost script for #{@patient.full_name}")
    end

    it 'creates new payment record' do
      expect(Payment.count).to eql(1)
    end
  end
end
