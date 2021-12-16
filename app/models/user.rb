class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :rates, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :suggests, dependent: :destroy

  PHONE_NUMBER_REGEX = /(84|0[3|5|7|8|9])+([0-9]{8})\b/i.freeze
  ID_CARD_REGEX = /([0-9]{9})||([0-9]{8})\b/i.freeze
  before_save :downcase_email

  validates :name, presence: true,
            length: {minimum: Settings.validate.length.digist_2},
            allow_nil: true

  validates :phone_number, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: PHONE_NUMBER_REGEX}, uniqueness: true,
            allow_nil: true

  validates :id_card, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: ID_CARD_REGEX}, uniqueness: true,
            allow_nil: true

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.link_expired.hours_2.hours.ago
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end
end
