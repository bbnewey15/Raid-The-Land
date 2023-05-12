extends Resource
class_name SlotData

@export var unit_data:  UnitData
@export var isEnemyUnit: bool
@export var column_name: GameData.COLUMN_STRING
@export var slotIndex: int
var slot_position: Vector2
@export var attack_order: int = 0
var can_attack : bool = true
var current_slot : Slot

func set_slot_position(pos: Vector2)->void:
	slot_position = pos

