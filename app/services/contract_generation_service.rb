class ContractGenerationService
    def initialize(project)
      @project = project
    end
  
    def generate_contract
      content = build_contract_content(@project)
      openai_response = OpenAiApi.generate_contract(content)
      save_contract(@project.id, openai_response["content"])
    end
  
    def update_contract(contract, section, new_content)
        instruction = "Update the #{section} section with the following content: #{new_content}"
        updated_content = OpenAiApi.edit_contract(contract.content, instruction)
        
        # Create a new version before updating the contract
        contract.create_version
    
        # Update the contract in the database
        contract.update(content: updated_content)
        contract
      end
  
    private
  
    def build_contract_content(project)
      sections = initialize_sections
  
      # Collect questions and answers from the project's questionnaires
      project.questionnaires.each do |q|
        q.questions.each do |question|
          sections[question.question_type] << question.answer
        end
      end
  
      # Add milestones to the contract content
      milestones_content = build_milestones_content(project)
  
      # Combine sections and milestones into the contract content
      content = <<~CONTENT
        Draft Legal Contract for Project: #{project.title}
  
        Contract Title: #{project.title}
        Date: #{Time.now.strftime('%Y-%m-%d')}
  
        1. Introduction
        #{sections['Introduction'].join("\n")}
  
        2. Scope of Work
        #{sections['Scope of Work'].join("\n")}
  
        3. Payment Terms
        #{sections['Payment Terms'].join("\n")}
  
        4. Responsibilities of Parties
        #{sections['Responsibilities of Parties'].join("\n")}
  
        5. Confidentiality
        #{sections['Confidentiality'].join("\n")}
  
        6. Termination
        #{sections['Termination'].join("\n")}
  
        7. Signatures
        #{sections['Signatures'].join("\n")}
  
        8. Milestones
        #{milestones_content}
  
        Please generate a detailed and professionally formatted legal contract based on all this content information. Utilize the format outline as well.
      CONTENT
  
      content
    end
  
    def initialize_sections
      {
        'Introduction' => [],
        'Scope of Work' => [],
        'Payment Terms' => [],
        'Responsibilities of Parties' => [],
        'Confidentiality' => [],
        'Termination' => [],
        'Signatures' => []
      }
    end
  
    def build_milestones_content(project)
      project.milestones.map do |milestone|
        <<~MILESTONE
          Title: #{milestone.title}
          Description: #{milestone.description}
          Deadline: #{milestone.deadline}
          Escrow Amount: $#{milestone.escrow_amount}
          Status: #{milestone.status}
        MILESTONE
      end.join("\n")
    end
  
    def save_contract(project_id, content)
      Contract.create(project_id: project_id, content: content).tap(&:save)
    end
  end

  class OpenAiApi

    # Move this to yml
    ACCESS_TOKEN = "".freeze
  
    def self.generate_contract(content)
      client = create_client
      response = client.completions(parameters: build_parameters(content))
      parse_response(response)
    end
  
    def self.edit_contract(original_text, instruction)
      prompt = <<~PROMPT
        The following is the current content of the contract:
  
        #{original_text}
  
        Please update the section with the following instruction: #{instruction}
  
        Return a new full contract with the revised section
  
        Updated Contract:
      PROMPT
  
      client = create_client
      response = client.completions(parameters: build_parameters(prompt))
      parse_response(response)
    rescue StandardError => e
      puts "Error during OpenAI API call: #{e.message}"
      nil
    end
  
    private
  
    def self.create_client
      OpenAI::Client.new(access_token: ACCESS_TOKEN, log_errors: true)
    end
  
    def self.build_parameters(prompt)
      {
        model: "gpt-3.5-turbo-instruct",
        prompt: prompt,
        max_tokens: 1000,
        temperature: 0.7
      }
    end
  
    def self.parse_response(response)
      { "id" => response["id"], "content" => response["choices"].first["text"].strip }
    end
  end
  