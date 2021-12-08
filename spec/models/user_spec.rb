require "rails_helper"

RSpec.describe User, type: :model do
  subject { FactoryBot.create :user }

  describe "associations" do
    it { should have_many(:orders).dependent(:destroy) }
  end

  context "validations" do
    it { should have_secure_password }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_length_of(:phone_number).is_at_least(6) }
    it { should validate_presence_of(:id_card) }
    it { should validate_length_of(:password).is_at_least(2) }

    it "do not allow emails with wrong format" do
      invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com foo bar@ @foobar @foobar.com]
      invalid_emails.each do |invalid_email|
        subject.email = invalid_email
        expect(subject).to be_invalid
      end
    end

    it "do not allow phone number with wrong format" do
      invalid_phones = []
      invalid_phones << "0a"
      invalid_phones << "0 a"
      invalid_phones << "11"
      invalid_phones << "+84123456789"
      invalid_phones << "+84 123"
      invalid_phones << "33-123"
      invalid_phones << "(333) 333"
      invalid_phones << "036.123"
      invalid_phones << "012-345"
      invalid_phones << "333.333 x12345"
      invalid_phones.each do |invalid_phone|
        subject.phone_number = invalid_phone
        expect(subject).to be_invalid
      end
    end
  end

  describe ".digest" do
    let(:digest) {User.digest("binh123")}

    it "should not nil" do
      expect(digest).not_to be nil
    end

    it "should return a string" do
      expect(digest).to be_kind_of String
    end

    it "should has length 60 character" do
      expect(digest.length).to eq(60)
    end
  end

  describe ".new_token" do
    let(:new_token) {User.new_token}

    it "should return a string" do
      expect(new_token).to be_kind_of String
    end

    it "should has length 22 character" do
      expect(new_token.length).to eq(22)
    end
  end

  describe "#authenticated?" do
    it "false with nil password" do
      subject.password_digest = nil
      expect(subject.authenticated?("password","binh123")).to be false
    end

    it "true with correct password" do
      expect(subject.authenticated?("password","binh123")).to be true
    end

    it "false with wrong password" do
      expect(subject.authenticated?("password","kt20072007")).to be false
    end
  end

  describe "#downcase_email" do
    it "should is downcase email before save to data" do
      email_user = FactoryBot.build(:user)
      email_user.email = "TeST@TESt.COM"
      email_user.save!
      expect(email_user.email).to eq "test@test.com"
    end
  end
end
