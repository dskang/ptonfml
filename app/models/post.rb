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
  attr_accessible :admin, :type

  # Type validation
  validates :type, presence: true

  # Comments
  has_many :comments, as: :commentable, dependent: :destroy

  has_attached_file :image

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

  # Make STI children use Post routes and controller
  def self.inherited(child)
    child.instance_eval do
      def model_name
        Post.model_name
      end
    end
    super
  end
end

class FML < Post
  attr_accessible :content

  validates :content, presence: true
end

class Meme < Post
  attr_accessible :image

  validates_attachment :image, presence: true, size: { in: 0..10.megabytes }

  def to_param
    id
  end
end

class GIF < Post
  attr_accessible :content, :image

  validates :content, presence: true
  validates_attachment :image, presence: true, size: { in: 0..10.megabytes }
  validates :image, attachment_content_type: { content_type: 'image/gif' }
end
