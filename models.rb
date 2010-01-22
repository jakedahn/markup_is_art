class Image < ActiveRecord::Base
  has_many :votes  
end

class Vote < ActiveRecord::Base
  belongs_to :image
end
