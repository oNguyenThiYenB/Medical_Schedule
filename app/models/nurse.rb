class Nurse < User
  NURSE_PARAMS = %i(user_name full_name email phone address
    password password_confirmation).freeze

  has_many :articles, dependent: :destroy
  has_many :conversations, foreign_key: :host_id
end
