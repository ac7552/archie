namespace :generate_mock_data do
    desc "Seeds the Database with users and a contract"
    task generate: :environment do
        User.create([
            { email: 'client@example.com', password: 'password', role: 'client' },
            { email: 'freelancer@example.com', password: 'password', role: 'freelancer' },
            { email: 'admin@example.com', password: 'password', role: 'admin' }
          ])

          client = User.find_by(email: 'client@example.com')
          freelancer = User.find_by(email: 'freelancer@example.com')

            Project.create([
            { title: 'AI Web Application Development', description: 'Development of a web app using AI to enhance user experience', user: client }
            ])

            project = Project.find_by(title: 'AI Web Application Development')

            Contract.create([
            { project: project, freelancer: freelancer, client: client, content: 'Contract details for AI web app development', status: 'draft', docusign_id: '12345', client_signed: false, contractor_signed: false, revisions: 'Initial draft' }
            ])

            Milestone.create([
                { project: project, title: 'Project Initiation', description: 'Kickoff meeting and requirement gathering', deadline: DateTime.now + 1.week, escrow_amount: 1000.0, status: 'pending' },
                { project: project, title: 'AI Model Development', description: 'Developing the AI model for the web app', deadline: DateTime.now + 1.month, escrow_amount: 5000.0, status: 'pending' },
                { project: project, title: 'Integration and Testing', description: 'Integrating the AI model with the web app and performing testing', deadline: DateTime.now + 2.months, escrow_amount: 3000.0, status: 'pending' },
                { project: project, title: 'Deployment', description: 'Deploying the web app to production', deadline: DateTime.now + 3.months, escrow_amount: 2000.0, status: 'pending' }
            ])

            Questionnaire.create([
                { project: project }
            ])

            questionnaire = Questionnaire.find_by(project: project)

            Question.create([
            { questionnaire: questionnaire, question: 'What features are most important for the AI model?', answer: '', question_type: 'open' },
            { questionnaire: questionnaire, question: 'What is the expected user base for the web app?', answer: '', question_type: 'open' }
            ])
    end
  end