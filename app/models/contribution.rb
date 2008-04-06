# !! This class isn't an ActiveRecord, it's used to hold
# a constant list of contributions.
class Contribution
  attr_accessor :name, :code, :local_sensitive, :quantified
  attr_accessor :desc, :parent

  def initialize(name, code, local_sensitive, quantified, desc, parent = nil)
    @name, @code, @local_sensitive, @quantified, @desc, @parent =
      name, code, local_sensitive, quantified, desc, parent
  end
end

CONTRIBUTIONS = []
CONTRIBUTIONS << Contribution.new(_('Personal Time'), 1, true, true, _('just some people time and commitment'))
CONTRIBUTIONS << Contribution.new(_('Money'), 2, false, true, _('funding through direct money donations'))

CONTRIBUTIONS << 
[Contribution.new(_('Knowledge'), 100, false, false, _('some general knowledge contributions.')),
  Contribution.new(_('Scientifical'), 101, false, false, _('scientifical knowledge contributions.')), 
  Contribution.new(_('Historical'), 102, false, false, _('historical knowledge contributions')), 
  Contribution.new(_('Geographical'), 103, false, false, _('geographical knowledge contributions')), 
  Contribution.new(_('Artistical'), 104, false, false, _('artistical contributions'))
]

CONTRIBUTIONS << 
[Contribution.new(_('Skills'), 200, false, false, _('basical skills contributions')),
  Contribution.new(_('Mechanical'), 201, false, false, _('mechanical skills contributions')),
  Contribution.new(_('Communication'), 202, false, false, _('communication skills contribution')),
]

CONTR_LOOKUP = {}
CONTRIBUTIONS.flatten.each { |contr| CONTR_LOOKUP[contr.code] = contr }
