extends Resource
class_name UnitColumnData



@export var slot_datas: Array[SlotData]
@export var column_type: GameData.COLUMN_TYPE
@export var colIndex: int

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data: 
		return slot_data
	else:
		return null


func get_player_occupies() -> bool:
	for slot_data in slot_datas:
		if slot_data.isEnemyUnit:
			return true
		
	return false

