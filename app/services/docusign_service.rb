require 'docusign_esign'
require 'base64'

class DocusignService
  attr_accessor :api_client

  def initialize
    base_path = 'https://demo.docusign.net/restapi'
    configuration = DocuSign_eSign::Configuration.new
    configuration.host = base_path
    @api_client = DocuSign_eSign::ApiClient.new(configuration)
  end

  def configure_client
    expires_in_seconds = 300
    integration_key = ""
    user_id = ""
    private_key = ""

    scopes = ["signature", "impersonation"]

    begin
      token = @api_client.request_jwt_user_token(integration_key, user_id, private_key, expires_in_seconds, scopes)
      @api_client.default_headers["Authorization"] = "Bearer #{token.access_token}"
      puts "Token: #{token.access_token}"
    rescue DocuSign_eSign::ApiError => e
      puts "Error: #{e.response_body}"
    end
  end

  def create_html_document(content)
    "<html><body>#{content}</body></html>"
  end

  def create_template(contract_content=Contract.last.content)
    configure_client

    document_html = create_html_document(contract_content)
    document_base64 = Base64.strict_encode64(document_html)

    template_document = DocuSign_eSign::Document.new(
      documentBase64: document_base64,
      name: 'Contract',
      fileExtension: 'html',
      documentId: '1'
    )

    sign_here = DocuSign_eSign::SignHere.new(
      documentId: '1',
      page_number: '1',
      recipientId: '1',
      tab_label: 'SignHereTab',
      anchor_string: '/signer/',
      anchor_units: 'pixels',
      anchor_x_offset: '0',
      anchor_y_offset: '0'
    )

    signer = DocuSign_eSign::Signer.new(
      email: 'aaron.campbell2590@gmail.com',
      name: 'Aaron',
      recipientId: '2',
      routing_order: '2'
    )

    signer.tabs = DocuSign_eSign::Tabs.new(sign_here_tabs: [sign_here])

    recipients = DocuSign_eSign::Recipients.new(signers: [signer])

    template_definition = DocuSign_eSign::EnvelopeTemplate.new(
      description: 'Template for contracts',
      name: 'Contract Template',
      shared: 'false',
      status: 'created',
      documents: [template_document],
      email_subject: 'Please sign this contract',
      recipients: recipients
    )

    templates_api = DocuSign_eSign::TemplatesApi.new(@api_client)
    account_id = '68ce7942-abc0-4bb7-a362-588f0d74991e'  # Replace with the actual account ID

    begin
      template_summary = templates_api.create_template(account_id, template_definition)
      puts "Template created with ID: #{template_summary.template_id}"
      template_summary.template_id
    rescue DocuSign_eSign::ApiError => e
      puts "Error: #{e.response_body}"
    end
  end

  def send_envelope(template_id, recipient_email, recipient_name)
    configure_client

    envelope_definition = DocuSign_eSign::EnvelopeDefinition.new(
      templateId: template_id,
      emailSubject: 'Please sign this contract',
      status: 'sent'
    )

    signer = DocuSign_eSign::TemplateRole.new(
      email: recipient_email,
      name: recipient_name,
      roleName: 'signer'
    )

    envelope_definition.template_roles = [signer]

    envelopes_api = DocuSign_eSign::EnvelopesApi.new(@api_client)
    account_id = ''  # Replace with the actual account ID

    begin
      envelope_summary = envelopes_api.create_envelope(account_id, envelope_definition)
      puts "Envelope sent with ID: #{envelope_summary.envelope_id}"
    rescue DocuSign_eSign::ApiError => e
      puts "Error: #{e.response_body}"
    end
  end

  def check_envelope_status(envelope_id)
    configure_client

    envelopes_api = DocuSign_eSign::EnvelopesApi.new(@api_client)
    account_id = ''  # Replace with the actual account ID

    begin
      envelope = envelopes_api.get_envelope(account_id, envelope_id)
      envelope_status = envelope.status
      puts "Envelope status: #{envelope_status}"
      
      if envelope_status == 'completed'
        puts "Envelope Signed!"
        # handle_envelope_completed(envelope_id)
      end
    rescue DocuSign_eSign::ApiError => e
      puts "Error: #{e.response_body}"
    end
  end
end
