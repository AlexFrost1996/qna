class Subscriber < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user
end
