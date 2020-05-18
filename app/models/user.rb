class User < ApplicationRecord
  ADDED_ATTRS = %i(user_name full_name email phone address position
  experience room role decription password password_confirmation
  remember_me).freeze

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  include Image

  self.inheritance_column = :role

  VALID_EMAIL_REGEX = Settings.valid_email_regex
  VALID_PHONE_REGEX = Settings.valid_phone_regex

  before_save :downcase_email

  has_one_attached :image
  has_many_attached :files

  validates :user_name, presence: true,
    length: {maximum: Settings.max_user_name}
  validates :full_name, presence: true,
    length: {maximum: Settings.max_user_name}
  validates :email, presence: true, length: {maximum: Settings.max_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_pass},
    allow_nil: true
  validates :image, content_type: {in: Settings.content_type,
                                   message: I18n.t("valid_image")},
    size: {less_than: Settings.imgsize5.megabytes,
           message: I18n.t("image_size")}

  scope :order_by_name, ->{order full_name: :asc}

  class << self
    def roles
      %w(Admin Staff Doctor Patient)
    end
  end

  %w(Admin Staff Doctor Patient).each do |klass|
    define_method "#{klass.downcase}?" do
      self.class.name == klass
    end
  end

  def display_image
    image.variant resize_to_limit: Settings.resize_to_limit
  end

  def check_user_to_show_info
    doctor? || staff?
  end

  private

  def downcase_email
    email.downcase!
  end
end
