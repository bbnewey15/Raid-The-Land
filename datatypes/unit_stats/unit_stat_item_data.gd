extends Resource
class_name UnitStatItemData

@export var display_name: String = "Stat Name"
@export var accessor : GameData.UNIT_DATA_ATTRIBUTES  = GameData.UNIT_DATA_ATTRIBUTES.DAMAGE
@export var value: int = 10
@export var display_order: int
@export var icon: Texture2D

func updateValue(new_value: int):
	self.value = new_value
	
