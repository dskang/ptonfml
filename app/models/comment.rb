# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  body             :text(255)
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  ip               :string(255)
#

class Comment < ActiveRecord::Base
  attr_accessible :name, :body
  validates :name, presence: true, length: { minimum: 1 }
  validates :body, presence: true, length: { minimum: 1 }

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  default_scope order: 'comments.created_at ASC'
end
