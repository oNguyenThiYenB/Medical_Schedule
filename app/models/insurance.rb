class Insurance < ApplicationRecord
  enum gender: { male: 0, female: 1, other: 2 }

  belongs_to :patient

  validates :card_number, presence: true,
    length: {maximum: 15, minimum: 15}
end
