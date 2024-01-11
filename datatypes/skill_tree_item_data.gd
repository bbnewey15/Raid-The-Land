extends Resource
class_name SkillTreeItemData

@export var item_name : String = "Skill Tree Item"
@export var attribute_link : GameData.UNIT_DATA_ATTRIBUTES = GameData.UNIT_DATA_ATTRIBUTES.DAMAGE
@export var num_levels : int = 3
@export var current_level : int = 0
@export var unlock_actions : Array[ActionData] = []

func increase_level(increase_by: int = 1):
	self.current_level = current_level + increase_by if current_level + increase_by <= num_levels else num_levels
