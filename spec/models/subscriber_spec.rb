require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
end
