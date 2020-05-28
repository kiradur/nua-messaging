class LostPrescriptionService
  DEFAULT_PRICE = 10
  LOST_PRESCRIPTION_MESSAGE = I18n.t('lost_prescription.default_admin_message').freeze
  SUCCESS_MESSAGE = I18n.t('lost_prescription.success_message').freeze
  FAILURE_MESSAGE = I18n.t('lost_prescription.failure_message').freeze

  attr_reader :payment_service, :issuer, :receiver

  def initialize payment_service: PaymentService, issuer:, receiver: User.default_admin
    @payment_service = payment_service
    @receiver = receiver
    @issuer = issuer
  end

  def process
    response = process_issuer_payment
    send_prescription_request_message if response[:success]
    response
  end

  private
  def process_issuer_payment
    payment_service.new(
      payment_provider_factory: PaymentProviderFactory,
      amount: DEFAULT_PRICE,
      issuer: issuer
    ).process
  end

  def send_prescription_request_message
    Message.create(
      body: LOST_PRESCRIPTION_MESSAGE,
      outbox: issuer.outbox,
      inbox: receiver.inbox
    )
  end
end

