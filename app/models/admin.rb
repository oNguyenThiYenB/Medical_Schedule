class Admin < User
  ADMIN_PARAMS = %i(user_name full_name email phone
     password password_confirmation).freeze
end
