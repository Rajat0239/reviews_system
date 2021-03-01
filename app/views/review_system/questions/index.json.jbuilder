unless @role_id.present?
  json.active_questions @questions do |question|
    if question.status
      json.id question.id
      json.question question.question
      json.question_type question.question_type.q_type
      json.options question.options
    end
  end
  json.inactive_questions @questions do |question|
    unless question.status
      json.id question.id
      json.question question.question
      json.question_type question.question_type.q_type
      json.options question.options
    end
  end
else
  @questions = Role.find(@role_id).questions
  json.questions @questions do |question|
    if question.status
      json.id question.id
      json.question question.question
      json.question_type question.question_type.q_type
      json.options question.options
    end
  end
end