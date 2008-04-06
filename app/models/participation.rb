require 'contribution'

class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :need

  validates_presence_of :part_type, :user_id, :need_id
  validates_numericality_of :quantity, :allow_nil => true

  def validate
    unless CONTR_LOOKUP[self.part_type]
      errors.add(:part_type, _("should be in the list of all existing contribution types"))
    end
  end
end
