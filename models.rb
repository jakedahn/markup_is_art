class Image < ActiveRecord::Base
  has_many :votes  
  
  def update_vote_count
    self.votes.sum('value')
    update(self.id, :title => "blah")
  end
  
end

class Vote < ActiveRecord::Base
  belongs_to :image
end
