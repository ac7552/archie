require_relative '../../config/environment'

user = User.first || User.create!(
  email: "john.doe@example.com",
  password: 'password123',
  password_confirmation: 'password123'
)

# Create a project
project = Project.create!(
  title: "Website Redesign",
  description: "Redesign the corporate website to improve user experience and engagement.",
  user_id: user.id
)

# Create a questionnaire for the project
questionnaire = Questionnaire.create!(project: project)

# Define question types and manually create questions
questions_data = [
  { question: "What is the primary goal of the project?", answer: "To redesign the corporate website to enhance user experience.", question_type: 'Introduction' },
  { question: "Who are the parties involved?", answer: "Client: ABC Corp, Contractor: XYZ Solutions", question_type: 'Introduction' },
  { question: "What tasks will be completed?", answer: "Design mockups, develop frontend and backend, conduct user testing.", question_type: 'Scope of Work' },
  { question: "What is the payment schedule?", answer: "50% upfront, 25% upon design approval, 25% upon project completion.", question_type: 'Payment Terms' },
  { question: "What are the client’s responsibilities?", answer: "Provide content and feedback on design.", question_type: 'Responsibilities of Parties' },
  { question: "How will sensitive information be handled?", answer: "All data will be encrypted and only accessible to authorized personnel.", question_type: 'Confidentiality' },
  { question: "Under what conditions can the contract be terminated?", answer: "Either party can terminate the contract with a 30-day notice.", question_type: 'Termination' },
  { question: "Who needs to sign the contract?", answer: "John Doe (Client) and Jane Smith (Contractor)", question_type: 'Signatures' }
]

# Create questions
questions_data.each do |question_data|
  Question.create!(
    questionnaire: questionnaire,
    question: question_data[:question],
    answer: question_data[:answer],
    question_type: question_data[:question_type]
  )
end

# Create milestones
milestones_data = [
  { title: "Project Kickoff", description: "Initial meeting to discuss project scope and goals.", deadline: "2024-07-01", escrow_amount: 5000.00, status: "Pending", project_id: project.id },
  { title: "Design Approval", description: "Submit design mockups for client approval.", deadline: "2024-08-01", escrow_amount: 2500.00, status: "Pending", project_id: project.id },
  { title: "Project Completion", description: "Complete development and launch the website.", deadline: "2024-09-01", escrow_amount: 2500.00, status: "Pending", project_id: project.id }
]

# Create milestones
milestones_data.each do |milestone_data|
  Milestone.create!(milestone_data)
end

puts "Seeded project '#{project.title}' with questions and milestones."