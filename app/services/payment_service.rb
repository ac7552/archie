class PaymentService
  def initialize(client, freelancer, project, milestone)
    @client = client
    @freelancer = freelancer
    @project = project
    @milestone = milestone
  end

  # Create a Stripe customer for the client
  def create_customer(payment_method_id)
    customer = Stripe::Customer.create({
      email: @client.email,
      payment_method: payment_method_id,
      invoice_settings: {
        default_payment_method: payment_method_id,
      },
    })

    # Save the customer ID to the client
    @client.update(stripe_customer_id: customer.id)

    customer
  rescue Stripe::StripeError => e
    raise StandardError, e.message
  end

  # Generate an account link for the freelancer
  def create_account_link(user)
    account = Stripe::Account.create({
      type: 'express',
      country: 'US',
      email: user.email,
      business_type: 'individual',
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true },
      },
    })

    # Save the connected account ID to the freelancer
    user.update(connected_account_id: account.id)

    # Create an account link for onboarding
    account_link = Stripe::AccountLink.create({
      account: account.id,
      refresh_url: "https://example.com/reauth",
      return_url: "https://example.com/return",
      type: 'account_onboarding',
    })

    account_link
  rescue Stripe::StripeError => e
    raise StandardError, e.message
  end

  # Create a payment intent for the milestone
  def create_payment_intent
    payment_intent = Stripe::PaymentIntent.create({
      amount: (10 * 100).to_i,
      currency: 'usd',
      payment_method: 'pm_card_visa',
      confirmation_method: 'manual',
      confirm: true,
      capture_method: 'manual',
      customer: @freelancer.stripe_customer_id,
      on_behalf_of: @client.connected_account_id,
      # metadata: { project_id: @project.id, milestone_id: @milestone.id },
      transfer_data: {
        destination: @client.connected_account_id,
      },
    })

    @milestone.update(stripe_payment_intent_id: payment_intent.id)
    payment_intent
  rescue Stripe::StripeError => e
    raise StandardError, e.message
  end

  # Release funds to the freelancer
  def release_funds
    customer = Stripe::Customer.retrieve(@freelancer.stripe_customer_id)
    default_payment_method = customer["invoice_settings"]["default_payment_method"]
    payment_intent = Stripe::PaymentIntent.retrieve(@milestone.stripe_payment_intent_id)
    if payment_intent.status == 'requires_capture'

      payment_intent.capture
      Stripe::Transfer.create({
        amount: payment_intent.amount,
        currency: 'usd',
        destination: @client.connected_account_id,
        transfer_group: '123',
      })


    elsif payment_intent.status == 'succeeded'
      raise "PaymentIntent has already been captured."
    else
      raise "PaymentIntent cannot be captured as it is in status: #{payment_intent.status}"
    end
  rescue Stripe::StripeError => e
    raise StandardError, e.message
  end
end