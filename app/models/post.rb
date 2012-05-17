class Post < ActiveRecord::Base
  attr_accessible :content

  def to_param
    preview = content.split(' ')[0..6].join(' ').parameterize
    "#{id}-#{preview}"
  end
end
