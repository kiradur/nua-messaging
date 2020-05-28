class PaymentProviderFactory
  def self.provider
    @provider ||= Provider.new
  end

  def debit_card(user) 
    '0101010101010101'
  end
end
