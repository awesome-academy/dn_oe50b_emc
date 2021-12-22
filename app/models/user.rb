class User < ApplicationRecord
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook]
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

  private

  def downcase_email
    email.downcase!
  end

  class << self
    def from_omniauth auth
      result = User.find_by email: auth.info.email
      return result if result

      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.uid = auth.uid
        user.provider = auth.provider

        user.skip_confirmation!
      end
    end
  end
end
