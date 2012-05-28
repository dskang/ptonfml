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

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
