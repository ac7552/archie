
class ContractsController < ApplicationController
  before_action :authenticate_user!, except: [:webhook]
  before_action :set_contract, only: [:show, :update, :destroy, :agree, :client_sign, :contractor_sign, :update_section, :send_for_signing]

  def create
    project = current_user.projects.find(params[:project_id])
    service = ContractGenerationService.new(project)
    contract = service.generate_contract
    render json: contract
  end

  def update_section
    section = params[:section]
    new_content = params[:new_content]

    service = ContractGenerationService.new(@contract.project)
    updated_contract = service.update_contract(@contract, section, new_content)

    render json: updated_contract
  end

  def create_clickwrap_agreement
      docusign_clickwrap_service = DocusignClickwrapService.new
      agreement_ids = docusign_clickwrap_service.create_clickwrap_agreements(@contract)
      render json: agreement_ids
  end
  

  def webhook
    json = JSON.parse(request.body.read)
    envelope_id = json['envelopeId']
    docusign_service = DocusignService.new
    docusign_service.update_signing_status(envelope_id)
    head :ok
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end
end
