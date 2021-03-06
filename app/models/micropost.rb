class Micropost < ApplicationRecord
  belongs_to :user
  #“箭头”句法，这表示一种对象，叫 Proc（procedure）或 lambda
  #-> 接受一个代码块，返回一个 Proc，然后在这个 Proc 上调用 call 方法执行其中的代码
  #设置默认排序方式
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture,PictureUploader
  validates :user_id,presence: true
  validates :content,presence: true,length: {maximum: 140}
  validate :picture_size
  private
  #验证上传的图像大小
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture,"should be less than 5MB")
    end
  end
end
