class User < ApplicationRecord
    attr_accessor :remember_token
    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                                    format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6}, allow_nil: true

    #returns hash digest of given string
    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt:: Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # returns random token
    def self.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        remember_digest.present?? BCrypt::Password.new(remember_digest).is_password?(remember_token): false
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
end
