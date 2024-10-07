
class MilestonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_milestone, only: [:show, :update, :destroy, :complete]

  # GET /milestones
  def index
    @milestones = Milestone.all
    render json: @milestones
  end

  # GET /milestones/:id
  def show
    render json: @milestone
  end

  # POST /milestones
  def create
    @milestone = Milestone.new(milestone_params)

    if @milestone.save
      payment_service = PaymentService.new(@milestone)
      payment_intent = payment_service.create_escrow
      render json: { milestone: @milestone, client_secret: payment_intent.client_secret }, status: :created
    else
      render json: @milestone.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /milestones/:id
  def update
    if @milestone.update(milestone_params)
      render json: @milestone
    else
      render json: @milestone.errors, status: :unprocessable_entity
    end
  end

  # DELETE /milestones/:id
  def destroy
    @milestone.destroy
  end

  # PATCH /milestones/:id/complete
  def complete
    if @milestone.update(status: 'completed')
      payment_service = PaymentService.new(@milestone)
      payment_service.release_funds
      render json: @milestone, status: :ok
    else
      render json: @milestone.errors, status: :unprocessable_entity
    end
  end

  private

  def set_milestone
    @milestone = Milestone.find(params[:id])
  end

  def milestone_params
    params.require(:milestone).permit(:project_id, :title, :description, :deadline, :escrow_amount, :status)
  end
end
