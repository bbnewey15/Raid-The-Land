extends Resource
class_name PerkData

@export var name = "Perk Name"
@export var description = "This is a perk"
@export var is_weakness : bool = false
@export var perk_type : GameData.PERK_TYPE = GameData.PERK_TYPE.STAT_ADJUST
@export var icon : Texture2D
var used : bool = false 

func addPerk(unit_data: UnitDataTest):
	pass
