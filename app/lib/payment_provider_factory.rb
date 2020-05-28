class PaymentProviderFactory
  def self.provider
    @provider ||= Provider.new
  end

  def debit_card(user) end;
end
