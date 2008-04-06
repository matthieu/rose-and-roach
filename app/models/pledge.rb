class Pledge < ActiveRecord::Base
  STATUS = {:accept => 1, :reject => 2, :confirmed => 3}

  belongs_to :user
  belongs_to :action
end
