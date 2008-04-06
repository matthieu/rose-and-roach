# The action type attribute defines whether it's a front action
# (type>0) or not (type==0). Front actions all have a different
# type number used to order them (1 being the first one on the
# list).
class Action < ActiveRecord::Base
  has_many :pledges
  belongs_to :project

  def front?
    self.type > 0
  end
end
