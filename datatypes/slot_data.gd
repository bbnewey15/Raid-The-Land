extends Resource
class_name SlotData


@export var unit_data_path :String
@export var unit_data: UnitDataTest
@export var isEnemyUnit: bool
@export var column_name: GameData.COLUMN_STRING
@export var slotIndex: int
var slot_position: Vector2
var action_targets : Array[SlotData]
var current_slot : Slot
@export var turn_over : bool = false
# Enemy uses the following:
@export var action_data : ActionData
@export var action_set : bool = false
@export var unit_deck : CardDeckData
##
signal intent_ready(slot_data: SlotData)

func init_unit_data(data: UnitDataTest):
	if data:
		unit_data = data
	else:
		var resource_template = load(unit_data_path)
		unit_data = resource_template.duplicate(true)
		unit_data.initialize()

func set_slot_position(pos: Vector2)->void:
	slot_position = pos

func can_action() -> bool:
	var will_action = true
	if unit_data.health <= 0:
		will_action = false
#	if action != GameData.UNIT_ACTIONS["ATTACK"]:
#		will_action = false
	
	return will_action

