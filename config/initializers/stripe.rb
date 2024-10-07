Stripe.api_key = ENV['CUSTOM_STRIPE_KEY']
Stripe.api_version = '2020-08-27'

Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['CUSTOM_STRIPE_KEY']
}