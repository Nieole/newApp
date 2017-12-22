module ApplicationHelper
	#定义一个获取默认网页标题的方法
	def full_title page_title = ''
		base_title="Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			page_title+" | "+base_title
		end
	end
	# def content_tag div,message,clazz
	# 	div_tag(class:"#{clazz[:class]}",value:"#{message}")
	# 	# <#{div} class=#{clazz[:class]}>#{message}</#{div}>
	# end
end
