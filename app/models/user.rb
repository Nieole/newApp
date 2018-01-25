class User < ApplicationRecord
	#指定对microposts模型为一对多关系，当用户被删除的时候，把对应的microposts连同删除
	has_many :microposts,dependent: :destroy
	has_many :active_relationships,class_name:"Relationship",foreign_key:"follower_id",dependent: :destroy
	has_many :passive_relationships,class_name: "Relationship",foreign_key:"followed_id",dependent: :destroy
	#使用 source 参数指定 following 数组由 followed_id 组成
	has_many :following,through: :active_relationships,source: :followed
	# has_many :followers,through: :passive_relationships,source: :follower
	has_many :followers,through: :passive_relationships
	attr_accessor :remember_token,:activation_token,:reset_token#令牌摘要
	before_save :downcase_email#将email转换为小写
	before_create :create_activation_digest# 创建并赋值激活令牌和摘要
	#验证name非空、最大长度为50
	validates :name, presence: true,length: {maximum: 50}
	#通过正则表达式验证email的合法性、非空、最大长度为255
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true,length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
	has_secure_password
	#验证password非空、最小长度为6
	validates :password, presence: true, length: { minimum: 6 },allow_nil:true
	#定义一个匿名类继承User
	class << self
		# 返回指定字符串的哈希摘要
		def digest string
			cost=ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
			BCrypt::Password.create(string,cost: cost)
		end
		#生成一个新的令牌
		def new_token
			#返回长度为22的随机字符串
			SecureRandom.urlsafe_base64
		end
	end
	#把记忆令牌和用户关联起来
	#为了持久保存会话，在数据库中记住用户
	def remember
		#对remember_token属性进行赋值
		self.remember_token=User::new_token
		#更新DB中的密码摘要字段
		update_attribute(:remember_digest,User.digest(remember_token))
	end
	#如果指定的令牌和摘要匹配，反回true
	def authenticated? attribute,token
		digest=send "#{attribute}_digest"
		#当digest为空时返回false
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end
	#忘记用户
	def forget
		update_attribute(:remember_digest,nil)
	end
	#激活账户
	def activate
		update_columns(activated:true,activated_at:Time.now)
		# update_attribute(:activated,true)
		# update_attribute(:activated_at,Time.now)
	end
	#发送激活邮件
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end
	#设置密码重设相关的属性
	def create_reset_digest
		self.reset_token=User.new_token
		update_columns(reset_digest:User.digest(reset_token),reset_sent_at:Time.now)
	end
	#发送密码重设邮件
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end
	#如果密码重设请求超时，返回true
	def password_reset_expired?
		#判断密码重设邮件是否已经发出超过两小时
		reset_sent_at < 2.hours.ago
	end
	#实现动态流原型
	def feed
		# Micropost.where("user_id=?",id)
		# following_ids等价于user.following.map { |i| i.to_s }
		# Micropost.where("user_id in (?) or user_id = ?",following_ids,id)
		# Micropost.where("User_id in (:following_ids) or user_id = :user_id",following_ids:following_ids,user_id:id)
		following_ids="select followed_id from relationships where follower_id = :user_id"
		Micropost.where("user_id in (#{following_ids}) or user_id = :user_id",user_id:id)
	end
	#关注另一个用户
	def follow other_user
		following << other_user
	end
	#取消关注另一个用户
	def unfollow other_user
		following.delete other_user
	end
	#如果当前用户关注了指定的用户，返回true
	def following? other_user
		following.include?(other_user)
	end
	private
	# 把电子邮件地址转换成小写
  def downcase_email
    email.downcase!
  end
	# 创建并赋值激活令牌和摘要
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
