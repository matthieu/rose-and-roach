require 'contribution'

class Need < ActiveRecord::Base
  belongs_to :project
  has_many :participations

  validates_presence_of :need_type, :project_id
  validates_length_of :desc, :maximum => 200

  def validate
    unless CONTR_LOOKUP[self.need_type]
      errors.add(:need_type, _("should be in the list of all existing contribution types"))
    end
  end
end
