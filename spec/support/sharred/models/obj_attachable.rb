shared_examples_for 'attachable object' do
  it {should have_many :attachments}
  it {should accept_nested_attributes_for :attachments}
end