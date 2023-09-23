class_name UnitDataTest extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var unit_node_path: String
@export var column_type: GameData.COLUMN_TYPE
@export var max_health: int = 100
@export var damage: int = 35
@export var support_amount : int = 15
@export var defend_ratio: float = .60
@export var status: String = "ALIVE"
@export var attack_requires_target = true
@export var defend_requires_target = false
@export var support_requires_target = false
@export var attack_number_target = 2
@export var defend_number_target = 0
@export var support_number_target = 1
@export var attack_range = [1]
@export var support_range = [0,1]

@export var health = max_health

signal unit_moved(id: int, direction: GameData.MOVE_DIRECTION)

# Put all methods for actions here?

func move_unit(direction: GameData.MOVE_DIRECTION ):
	unit_moved.emit(self.get_instance_id(), direction)
	
func update_health(new_health: int):
	health = new_health

func requires_target(action: GameData.UNIT_ACTIONS):
	match action:
		GameData.UNIT_ACTIONS["ATTACK"]:
			return attack_requires_target
		GameData.UNIT_ACTIONS["DEFEND"]:
			return defend_requires_target
		GameData.UNIT_ACTIONS["SUPPORT"]:
			return support_requires_target
		_:
			push_warning("Default value used in unit_data's requires_target")
			return false

func number_of_targets(action: GameData.UNIT_ACTIONS):
	match action:
		GameData.UNIT_ACTIONS["ATTACK"]:
			return attack_number_target
		GameData.UNIT_ACTIONS["DEFEND"]:
			return defend_number_target
		GameData.UNIT_ACTIONS["SUPPORT"]:
			return support_number_target
		_:
			push_warning("Default value used in unit_data's number_of_targets")
			return 0

func get_range_by_action(action: GameData.UNIT_ACTIONS) -> Array:
	match action:
		GameData.UNIT_ACTIONS["ATTACK"]:
			return self.attack_range
		GameData.UNIT_ACTIONS["DEFEND"]:
			return []
		GameData.UNIT_ACTIONS["SUPPORT"]:
			return self.support_range
		_:
			assert(false)
			return []
	
