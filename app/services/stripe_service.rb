class StripeService
  def self.create_connected_account(email, ip)

    account = Stripe::Account.create({
      type: 'custom',
      country: 'US',
      email: email,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true },
      },
      business_type: 'individual',
      business_profile: {
        mcc: '5045', # Example MCC (Merchant Category Code)
        url: 'https://your-business.com',
      },
      tos_acceptance: {
        date: Time.now.to_i,
        ip: ip # IP address of the user accepting the TOS
      }
    })

    account.id
  end

  def self.add_external_card(connected_account_id, token)

    Stripe::Account.create_external_account(
      connected_account_id,
      {
        external_account: token,
      }
    )
  end
end