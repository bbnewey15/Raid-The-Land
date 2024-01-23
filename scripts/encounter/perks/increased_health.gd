extends PerkData
class_name PerkIncreasedHealth

@export var increase_amount : int = 10 

func  addPerk(unit_data: UnitDataTest):
	if self.used == false:
		self.used = true
	else:
		return
	
	unit_data.stat_data.updateAttribute(GameData.UNIT_DATA_ATTRIBUTES.MAX_HEALTH,unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.MAX_HEALTH ).value + self.increase_amount )
