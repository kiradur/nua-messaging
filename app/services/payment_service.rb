class PaymentService
  attr_reader :payment_provider_factory, :issuer, :amount

  def initialize payment_provider_factory:, issuer:, amount:
    @payment_provider_factory = payment_provider_factory
    @issuer = issuer
    @amount = amount

    @fake_success = true
  end

  def process
    process_payment
  end

  private
  def process_payment
    # ActiveRecord::Base.transaction do
      # processing ...
      debit_card_number = get_issuer_debit_card
      issuer.payments.create(
        debit_card_last_four_digits: get_last_four_digits(debit_card_number)
      )
      # processing ...
    # end

    response = { success: @fake_success }
    return handle_payment_success if response[:success]
    handle_payment_failure
  end

  def get_last_four_digits(debit_card_number)
    debit_card_number.split(//).last(4).join
  end

  def get_issuer_debit_card
    @payment_provider_factory.new.debit_card(@issuer)
  end

  def handle_payment_success
    form_success_message
  end

  def handle_payment_failure
    form_error_message
  end

  def form_success_message
    { success: true }
  end

  def form_error_message
    { success: false }
  end

end
