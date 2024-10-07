require 'byebug'

class PaymentsController < ApplicationController
  before_action :set_project_and_milestone

  def create_account_link
    user = User.find_by(email: params[:email])

    payment_service = PaymentService.new(@project.client, @project.freelancer, @project, @milestone)
    account_link = payment_service.create_account_link(user)

    render json: { message: 'Account created successfully', account_link_url: account_link.url }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create_customer
    user = User.create!(email: params[:email], password: '123567', role: params[:role])

    payment_service = PaymentService.new(user, @project.freelancer, @project, @milestone)
    byebug
    customer = payment_service.create_customer(params[:payment_method_id])
    byebug
    render json: { message: 'Customer created successfully', customer_id: customer.id }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create_payment_intent
    payment_service = PaymentService.new(@project.client, @project.freelancer, @project, @milestone)
    payment_intent = payment_service.create_payment_intent

    render json: { client_secret: payment_intent.client_secret, payment_intent_id: payment_intent.id }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def release_funds
    payment_service = PaymentService.new(@project.client, @project.freelancer, @project, @milestone)
    payment_intent = payment_service.release_funds

    render json: { message: "Funds released successfully", payment_intent_id: payment_intent.id }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_project_and_milestone
    @project = Project.find(params[:project_id])
    @milestone = @project.milestones.find(params[:milestone_id])
  end
end
