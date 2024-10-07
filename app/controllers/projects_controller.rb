
class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    render json: @project
  end

  def index
    @projects = Project.all
    render json: { projects: @projects }
  end

  def user_projects
    @project = Project.includes(:milestones).where(client_id: params[:client_id]).last
    render json: @project.to_json(:include => :milestones) 
  end
  def create
    @project = Project.new(title: params[:title], description: params[:description], freelancer_id: params[:freelancer_id], client_id: params[:client_id])
    if @project.save
      save_questionnaire_responses if params[:questionnaire].present?
      save_milestones if params[:milestones].present?
      generate_contract
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  private

  def save_questionnaire_responses
    questionnaire = Questionnaire.create(project_id: @project.id)
    params[:questionnaire].each do |question, answer|
      Question.create!(question_type: question, question: answer, questionnaire_id: questionnaire.id)
    end
  end

  def save_milestones
    params[:milestones].each do |milestone_params|
      next if milestone_params["title"].blank?

      @project.milestones.create!(
        title: milestone_params["title"],
        description: milestone_params["description"],
        deadline: milestone_params["deadline"],
        escrow_amount: milestone_params["escrowAmount"]
      )
    end
  end

  def generate_contract
    contract_service = ContractGenerationService.new(@project)
    contract_service.generate_contract
    #DocusignService.new.send_for_signing
    #ContractMailer.contract_ready(@project.contract).deliver_later
  end
end