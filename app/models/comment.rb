class Comment < ActiveRecord::Base
  attr_accessible :name, :body
  validates :name, presence: true, length: { minimum: 1 }
  validates :body, presence: true, length: { minimum: 1 }

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  default_scope order: 'comments.created_at ASC'
end
