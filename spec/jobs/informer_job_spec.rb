require 'rails_helper'

RSpec.describe InformerJob, type: :job do
  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}
  let(:answer) {create(:answer, question: question)}

  it 'sends notification about adding new answer' do
    expect(Informer).to receive(:inform_about_answer).with(answer)
    InformerJob.perform_now(answer)
  end

end
