module UsersHelper
	#定义一个获取gravatar提供的获取邮箱形象图片的方法并返回一个image标签
	def gravatar_for user,size:80
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url="https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end
end
