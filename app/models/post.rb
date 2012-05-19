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
#

class Post < ActiveRecord::Base
  attr_accessible :content
  validates :content, presence: true
  has_many :comments, as: :commentable

  def to_param
    words = content.split(' ')
    words_in_preview = [words.length, 7].min
    preview = words[0..(words_in_preview - 1)].join(' ').parameterize
    "#{id}-#{preview}"
  end

  default_scope order: 'posts.created_at DESC'
end
