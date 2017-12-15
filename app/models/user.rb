class User < ApplicationRecord
	attr_accessor :remember_token#令牌摘要
	before_save { email.downcase! }#将email转换为小写
	#验证name非空、最大长度为50
	validates :name, presence: true,length: {maximum: 50}
	#通过正则表达式验证email的合法性、非空、最大长度为255
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true,length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
	has_secure_password
	#验证password非空、最小长度为6
	validates :password, presence: true, length: { minimum: 6 }
	class << self
		# 返回指定字符串的哈希摘要
		def digest string
			cost=ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
			BCrypt::Password.create(string,cost: cost)
		end
		#生成一个新的令牌
		def new_token
			SecureRandom.urlsafe_base64
		end
	end
	#把记忆令牌和用户关联起来
	#为了持久保存会话，在数据库中记住用户
	def remember
		#对remember_token属性进行赋值
		self.remember_token=User::new_token
		#跟新DB中的密码摘要字段
		update_attribute(:remember_digest,User.digest(remember_token))
	end
end
