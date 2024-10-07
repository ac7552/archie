
class DocusignController < ApplicationController
  def initialize
    @docusign_service = DocusignService.new
  end

  def create_template
    contract_content = params[:content]
    template_id = @docusign_service.create_template(contract_content)
    if template_id
      render json: { template_id: template_id }, status: :ok
    else
      render json: { error: 'Failed to create template' }, status: :unprocessable_entity
    end
  end

  def send_envelope
    template_id = params[:template_id]
    recipient_email = params[:recipient_email]
    recipient_name = params[:recipient_name]
    envelope_id = @docusign_service.send_envelope(template_id, recipient_email, recipient_name)
    if envelope_id
      render json: { envelope_id: envelope_id }, status: :ok
    else
      render json: { error: 'Failed to send envelope' }, status: :unprocessable_entity
    end
  end

  def check_envelope_status
    envelope_id = params[:envelope_id]
    status = @docusign_service.check_envelope_status(envelope_id)
    if status
      render json: { status: status }, status: :ok
    else
      render json: { error: 'Failed to check envelope status' }, status: :unprocessable_entity
    end
  end
end
