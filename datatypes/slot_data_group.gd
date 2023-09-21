extends Resource
class_name SlotDataGroup

@export var slot_datas: Array[SlotData]
@export var isEnemy: bool

func get_data_in_action_order() -> Array[SlotData]:
	return slot_datas
