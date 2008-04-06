# !! This class isn't an ActiveRecord, it's used to hold
# a constant list of contributions.
class Resource
  attr_accessor :name, :code, :quantified, :desc

  def initialize(name, code, quantified, desc)
    @name, @code, @quantified, @desc = name, code, quantified, desc
  end
end

RESOURCES = [
  Resource.new(_('Electricity Consumption'), 1, true, _('By reducing electricity consumption, you have an impact on the whole electricity production chain. Most ways to produce electricity nowadays are polluting, especially from fossil fuel.')),
  Resource.new(_('Greenhouse Gas Emission & Air Pollution'), 2, true, _('Greenhouse gases contribute to the Greenhouse effect, which is now recognized as the main driver of Global Warming.')),
  Resource.new(_('Water'), 3, true, _('Due to the accrued humna consumption of water siince the 70s and to the current time, a water crisis has emerged. About 1.1 billion people have limited or no access to drinking water worldwide and even advanced countries are suffering from aquifers in overdraft.')),
  Resource.new(_('Water Pollution'), 4, true, _('Water pollution affects lakes, oceans, rivers and groundwater and is caused by human activity. It has been suggested that it is the leading worldwide cause of deaths and diseases and contributes to the destruction of entire ecosystems.')),
  Resource.new(_('Soil Pollution'), 5, true, _('The concern over soil contamination stems primarily from health risks, both of direct contact and from secondary contamination of water supplies.'))
]

RES_LOOKUP = {}
RESOURCES.each { |res| RES_LOOKUP[res.code] = res }

class Unit
  attr_accessor :symbol, :code
  def initialize(symbol, code)
    @symbol, @code = symbol, code
  end
end

UNITS = [
  Unit.new('L', 1),
  Unit.new('kW', 2),
  Unit.new('Ton', 3)
]

UNITS_LOOKUP = {}
UNITS.each { |res| UNITS_LOOKUP[res.code] = res }
