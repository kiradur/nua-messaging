class MessagesController < ApplicationController
  include Pagy::Backend
  before_action :get_user_messages, only: :index

  def index
    @pagy, @messages = pagy(@messages, page: params[:page], items: 9)
  end

  def show
    @message = Message.find(params[:id])
    @message.mark_as_read
  end

  def new
    @message = Message.new
  end

  def create
    @message = new_message

    if @message.save
      redirect_to messages_path
    else
      render action: :new
    end
  end

  private

  def get_user_messages
    @messages = current_user.inbox.messages.order(created_at: :desc)
  end
  
  def new_message
    @message = Message.new(
      permitted_params.merge({
        outbox_id: current_user_outbox.id,
        inbox_id: original_message.receiver_inbox.id
      })
    )
  end

  def current_user_outbox
    current_user.outbox
  end

  def original_message
    Message.find(params[:original_message_id])
  end

  def permitted_params
    params.require(:message).permit(:body)
  end

end
