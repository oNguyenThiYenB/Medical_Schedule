class Ability
  include CanCan::Ability

  def initialize user
    can :read, Doctor
    can [:new, :for_faculty_id, :for_doctor_id, :for_date_picker], Appointment
    return unless user

    can [:show, :update], User, id: user.id

    case user.role
    when "Admin"
      can :manage, :all
    when "Staff"
      can :update, Doctor
      can :index, Patient
      can :manage, Appointment
      can :manage, Article
    when "Doctor"
      can :read, Comment
    when "Patient"
      can [:create], Appointment
      can :manage, Comment, patient_id: user.id
    end
  end
end
