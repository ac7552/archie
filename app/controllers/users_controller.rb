
class UsersController <  Devise::UsersController

  def add_card
    user = current_user

    customer = Stripe::Customer.create(email: user.email)
    user.update(stripe_customer_id: customer.id)

    card = Stripe::Customer.create_source(
      user.stripe_customer_id,
      { source: params[:stripe_token] }
    )

    user.update(stripe_card_id: card.id)
    render json: { success: true }
  end

  def show 
    @user = User.find_by(params[:id])
    render json: { user: @user }, status: :ok
  end

  def add_debit_card
    user = current_user

    customer = Stripe::Customer.create(email: user.email)
    user.update(stripe_customer_id: customer.id)

    card = Stripe::Customer.create_source(
      user.stripe_customer_id,
      { source: params[:stripe_token] }
    )

    user.update(stripe_card_id: card.id)
    render json: { success: true }
  end
end
