require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award) }
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  
  it_behaves_like 'votable model'
  it_behaves_like 'commentable model'
  
  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many) 
  end
end
