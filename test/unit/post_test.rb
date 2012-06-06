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

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
