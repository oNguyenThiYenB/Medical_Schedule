class Staff < User
  STAFF_PARAMS = %i(user_name full_name email phone address
    password password_confirmation).freeze

  has_many :articles, dependent: :destroy
  has_many :conversations, foreign_key: :host_id

  scope :order_by_name, ->{order full_name: :asc}
end
