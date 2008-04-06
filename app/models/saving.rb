require 'contribution'

class Saving < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :saving_type, :project_id
  validates_length_of :desc, :maximum => 200

  def validate
    unless RES_LOOKUP[self.saving_type]
      errors.add(:saving_type, _("should be in the list of all existing resource types."))
    end
  end
end
