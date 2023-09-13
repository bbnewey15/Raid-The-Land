extends Resource
class_name SlotData



@export var unit_data_path :String
@export var unit_data: UnitDataTest
@export var isEnemyUnit: bool
@export var column_name: GameData.COLUMN_STRING
@export var slotIndex: int
var slot_position: Vector2
@export var attack_order: int = 0
var attack_targets : Array[SlotData]
var action : GameData.UNIT_ACTIONS
var action_set : bool = false
var current_slot : Slot

func init_unit_data(data: UnitDataTest):
	if data:
		unit_data = data
	else:
		var resource_template = load(unit_data_path)
		unit_data = resource_template.duplicate(true)

func set_slot_position(pos: Vector2)->void:
	slot_position = pos

func can_attack() -> bool:
	var will_attack = true
	if unit_data.health <= 0:
		will_attack = false
	if action != GameData.UNIT_ACTIONS["ATTACK"]:
		will_attack = false
	
	return will_attack
