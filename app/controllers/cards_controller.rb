
    class CardsController < ApplicationController
      def new
        # This action will render the form for adding a card
        render :new
      end

      def add_card
        token = params[:token]
        connected_account_id = params[:connected_account_id]
        puts StripeService.add_external_card(connected_account_id, token)

        render json: { status: 'success' }
      rescue Stripe::StripeError => e
        render json: { error: e.message }, status: 400
      end
    end
