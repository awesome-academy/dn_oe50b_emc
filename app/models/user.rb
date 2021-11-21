class User < ApplicationRecord
  has_many :rates, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :suggests, dependent: :destroy
  attr_accessor :remember_token, :activation_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  PHONE_NUMBER_REGEX = /(84|0[3|5|7|8|9])+([0-9]{8})\b/i.freeze
  ID_CARD_REGEX = /([0-9]{9})||([0-9]{8})\b/i.freeze
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, :email, presence: true
  validates :name,
            length: {minimum: Settings.validate.length.digist_2}

  validates :email,
            length: {maximum: Settings.validate.length.digist_255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  validates :phone_number, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: PHONE_NUMBER_REGEX}, uniqueness: true

  validates :id_card, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: ID_CARD_REGEX}, uniqueness: true

  has_secure_password

  validates :password, presence: true,
            length: {minimum: Settings.validate.length.digist_2},
            allow_nil: true

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
