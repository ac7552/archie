class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    event = nil

    begin
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.dig(:stripe, :endpoint_secret)
      )
    rescue JSON::ParserError => e
      render status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render status: 400
      return
    end

    case event['type']
    when 'payment_intent.succeeded'
      handle_payment_intent_succeeded(event['data']['object'])
    when 'payment_intent.payment_failed'
      handle_payment_intent_failed(event['data']['object'])
    when 'payout.paid'
      handle_payout_paid(event['data']['object'])
    when 'payout.failed'
      handle_payout_failed(event['data']['object'])
    else
      render json: { message: 'Unhandled event type' }, status: 400
    end

    render json: { message: 'success' }, status: 200
  end

  private

  def handle_payment_intent_succeeded(payment_intent)
    milestone = Milestone.find_by(stripe_payment_intent_id: payment_intent['id'])
    if milestone
      milestone.update(status: 'funded')
      # Additional logic for handling successful payment
    end
  end

  def handle_payment_intent_failed(payment_intent)
    milestone = Milestone.find_by(stripe_payment_intent_id: payment_intent['id'])
    if milestone
      milestone.update(status: 'payment_failed')
      # Additional logic for handling failed payment
    end
  end

  def handle_payout_paid(payout)
    # Logic for handling successful payout
  end

  def handle_payout_failed(payout)
    # Logic for handling failed payout
  end
end