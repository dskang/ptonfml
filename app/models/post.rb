class Post < ActiveRecord::Base
  attr_accessible :content
  validates :content, presence: true

  def to_param
    words = content.split(' ')
    words_in_preview = [words.length, 7].min
    preview = words[0..(words_in_preview - 1)].join(' ').parameterize
    "#{id}-#{preview}"
  end
end
