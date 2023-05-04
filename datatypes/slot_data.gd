extends Resource
class_name SlotData

@export var unit_data:  UnitData
@export var isEnemyUnit: bool
@export var column_name: GameData.COLUMN_STRING
@export var slotIndex: int
var slot_position: Vector2
var attack_order: int


func set_slot_position(pos: Vector2)->void:
	slot_position = pos

