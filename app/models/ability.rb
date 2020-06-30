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
      can [:read], Patient
      can :manage, Appointment
      can :manage, Article
      can :manage, Conversation
      can :manage, Message
    when "Doctor"
      can :read, Comment
      can :read, Patient
      can [:new, :create, :update], Article
      can [:read, :update], Appointment, doctor_id: user.id
    when "Patient"
      can [:create, :read, :update], Appointment, patient_id: user.id
      can [:index], Conversation
      can :manage, Message
      can :manage, Comment, patient_id: user.id
    when "Nurse"
      can :manage, Conversation
      can [:read], Patient
      can [:read, :update], Appointment
      can [:new, :create, :update], Article
      can :manage, Message
    end
  end
end
