
class QuestionnairesController < ApplicationController
  before_action :authenticate_user!

  def create
    @project = current_user.projects.find(params[:project_id])
    @questionnaire = @project.questionnaires.create
    render json: @questionnaire
  end

  def add_question
    @questionnaire = Questionnaire.find(params[:id])
    @question = @questionnaire.questions.create(question_params)
    render json: @question
  end

  private

  def question_params
    params.require(:question).permit(:question, :answer)
  end
end
 