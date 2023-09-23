class_name CardSlotData extends Resource

@export var unit_data:  UnitDataTest
# Abstract card means does the card physically play a unit or does it abstractly affect the game?
@export var abstract_card: bool

func init_unit_data(data: UnitDataTest):
	if data:
		unit_data = data
	else:
		unit_data = unit_data.duplicate(true)

var slot_position: Vector2

func set_slot_position(pos: Vector2)->void:
	slot_position = pos
