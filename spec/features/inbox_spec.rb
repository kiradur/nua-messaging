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
      visit messages_path
      click_button 'Change User'
      click_on 'Doctor'
    end

    it 'shows number of unred messages' do
      expect(page).to have_content('New Messages: 1')
      Message.create(body: 'New message', inbox: @doctor.inbox, outbox: @patient.outbox)
      visit messages_path
      expect(page).to have_content('New Messages: 2')
    end

    it 'decrements number of unread messages after message is opened' do
      Message.create(body: 'New message', inbox: @doctor.inbox, outbox: @patient.outbox)
      visit messages_path
      expect(page).to have_content('New Messages: 2')

      first('.tab-content > .tab-pane > a').click
      visit messages_path
      expect(page).to have_content('New Messages: 1')
    end

  end
end
