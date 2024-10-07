require 'byebug'
class InvitationsController < ApplicationController
  #before_action :authenticate_user! # Assuming you are using Devise for user authentication

  def create
    setup_invite
    if @invitation.save!
      # Here you might add logic to send an actual email invitation
      render json: @invitation, status: :created
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end

  def fetch_clients 
    @clients = Invitation.where(sender_id: params[:user_id])
    render json: {data: @clients}, status: :ok
  end

  def setup_invite
    # Consider moving to transaction later 
    @invitation = Invitation.new(sender_id: params[:invitation][:user_id], recipient_email: params[:invitation][:recipient_email], sent_at: Time.current)
    @user = User.first_or_create(email: params[:invitation][:recipient_email])
    # @project = Project.create!(freelancer_id: @user.id, client_id: params[:invitation][:user_id])
    @user.save!
    @invitation.user_id = @user.id
  end
  
end