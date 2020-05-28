class MessagesController < ApplicationController
  include Pagy::Backend

  def index
    @messages = User.default_doctor.inbox.messages.order(created_at: :desc)
    @pagy, @messages = pagy(@messages, page: params[:page], items: 9)
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    @message = new_message

    if @message.save
      render action: :index
    else
      render action: :new
    end
  end

  private
  
  def new_message
    @message = Message.new(
      permitted_params.merge({
        outbox_id: current_user_outbox.id,
        inbox_id: original_message.receiver_inbox.id
      })
    )
  end

  def current_user_outbox
    User.current.outbox
  end

  def original_message
    Message.find(params[:original_message_id])
  end

  def permitted_params
    params.require(:message).permit(:body)
  end

end
