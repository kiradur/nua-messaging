require 'rails_helper'

RSpec.describe MessagesController, type: :controller do

  describe 'CREATE message' do
    let(:patient) { create :user, :patient }
    let(:doctor) { create :user, :doctor }
    let!(:admin) { create :user, :admin }

    let(:message_params) { FactoryBot.attributes_for(:message) }

    let!(:doctor_message) { create :message, {
        outbox: doctor.outbox,
        inbox: patient.inbox
      }
    }

    let!(:doctor_message_sent_1_week_ago) { create :message, :sent_1_week_ago, {
        outbox: doctor.outbox,
        inbox: patient.inbox
      }
    }

    it 'creates message with unread status' do
      expect { post :create, params: {
          original_message_id: doctor_message.id,
          message: message_params
        }
      }.to change(Message.where(read: false), :count).by(1)
    it 'increments the number of unread messages when doctor gets a message' do
      expect { post :create, params: {
          original_message_id: doctor_message.id,
          message: message_params
        }
      }.to change { doctor.inbox.reload.unread_messages }.from(0).to(1)
    end

    context 'Reply to message created up to 1 week ago' do
      it 'puts message in doctors inbox' do
        post :create, params: {
          original_message_id: doctor_message.id,
          message: message_params
        }

        new_message = Message.last
        expect(Message.last.inbox.user.is_doctor).to be_truthy
      end
    end

    context 'Reply to message older then 1 week ago' do
      it 'puts message in admins inbox' do
        post :create, params: {
          original_message_id: doctor_message_sent_1_week_ago.id,
          message: message_params
        }

        new_message = Message.last
        expect(Message.last.inbox.user.is_admin).to be_truthy
      end
    end
  end

  describe 'SHOW message' do
    let(:doctor) { create :user, :doctor }
    let(:patient) { create :user, :patient }

    it 'decrements number of unread messages when a doctor reads a message' do
      message = FactoryBot.create(:message, {
        outbox: patient.outbox,
        inbox: doctor.inbox
      })

      expect { get :show, params: {
          id: message.id
        }
      }.to change { doctor.inbox.reload.unread_messages }.from(1).to(0)
    end
  end

  describe 'Issue Lost Prescription' do
    let!(:admin) { create :user, :admin }
    let(:patient) { create :user, :patient }
    let(:doctor) { create :user, :doctor }
    let(:doctor_message) { create :message, {
        outbox: doctor.outbox,
        inbox: patient.inbox
      }
    }

    it 'create user payment record' do
      expect { post :lost_prescription, params: {
          id: doctor_message.id
        }
      }.to change(admin.inbox.messages, :count).by(1)
    end

    it 'gets issuer debit card details (PaymentProviderFactory)' do
      number = Faker::Number.number(digits: 21).to_s
      allow_any_instance_of(PaymentProviderFactory).to receive(:debit_card).and_return(number)

      post :lost_prescription, params: {
        id: doctor_message.id
      }

      expect(patient.payments.last.debit_card_last_four_digits).to eql(number.split(//).last(4).join)
    end

    it 'create user payment record' do
      expect { post :lost_prescription, params: {
          id: doctor_message.id
        }
      }.to change(patient.payments, :count).by(1)
    end

    it 'show flash error message when payment will fail' do
      allow_any_instance_of(LostPrescriptionService).to receive(:process).and_return({success: false})

      post :lost_prescription, params: {
        id: doctor_message.id
      }

      expect(response).to redirect_to(message_path(id: doctor_message.id ))
      expect(flash[:alert]).to be_present
    end
  end
end
