class Staff < User
  STAFF_PARAMS = %i(user_name full_name email phone address
    password password_confirmation).freeze

  has_many :articles, dependent: :destroy

  scope :order_by_name, ->{order full_name: :asc}
end
