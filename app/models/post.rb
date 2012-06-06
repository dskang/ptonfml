# == Schema Information
#
# Table name: posts
#
#  id                 :integer         not null, primary key
#  content            :text
#  likes              :integer         default(0)
#  dislikes           :integer         default(0)
#  approved           :boolean         default(FALSE)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  ip                 :string(255)
#  admin              :boolean         default(FALSE)
#  type               :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  reviewed           :boolean         default(FALSE)
#  phone              :string(255)
#

class Post < ActiveRecord::Base
  attr_accessible :admin, :type, :image

  # Type validation
  validates :type, presence: true

  # Comments
  has_many :comments, as: :commentable, dependent: :destroy

  # Image
  has_attached_file :image, styles: { original: "500x500>" },
  storage: :s3,
  bucket: ENV['S3_BUCKET_NAME'],
  s3_credentials: {
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }

  def to_param
    words = content.split(' ')
    words_in_preview = [words.length, 7].min
    preview = words[0..(words_in_preview - 1)].join(' ').parameterize
    "#{id}-#{preview}"
  end

  scope :approved, where(approved: true)
  scope :unreviewed, where(reviewed: false)
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
  validates_attachment :image, presence: true, size: { in: 0..4.megabytes }

  def to_param
    id
  end
end

class GIF < Post
  attr_accessible :content

  validates :content, presence: true
  validates_attachment :image, presence: true, size: { in: 0..4.megabytes }
  validates :image, attachment_content_type: { content_type: 'image/gif' }
end
