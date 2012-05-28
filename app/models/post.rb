# == Schema Information
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  content    :text
#  likes      :integer         default(0)
#  dislikes   :integer         default(0)
#  approved   :boolean         default(FALSE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  ip         :string(255)
#  admin      :boolean         default(FALSE)
#  type       :string(255)
#

class Post < ActiveRecord::Base
  attr_accessible :content, :admin
  validates :content, presence: true, length: { minimum: 1 }
  has_many :comments, as: :commentable, dependent: :destroy

  def to_param
    words = content.split(' ')
    words_in_preview = [words.length, 7].min
    preview = words[0..(words_in_preview - 1)].join(' ').parameterize
    "#{id}-#{preview}"
  end

  scope :approved, where(approved: true)
  scope :recent, order: 'posts.created_at DESC'
  scope :most_liked, order: 'posts.likes DESC'
  scope :most_disliked, order: 'posts.dislikes DESC'
end
