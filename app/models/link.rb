class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, url: { no_local: true, schemes: ['http', 'https'], public_suffix: true }
end
