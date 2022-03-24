require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:answer) { create(:answer) }

  it 'calls NotificationService #notify_question_subscribers' do
    expect(NotificationService).to receive(:notify_question_subscribers).with(answer.question)
    NotificationJob.perform_now(answer.question)
  end
end
