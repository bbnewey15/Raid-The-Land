extends Resource
class_name CardHandData

signal card_interact(card_hand_data: CardHandData, index: int, button: int)

@export var slot_datas: Array[CardSlotData]
@export var is_player: bool

func grab_slot_data(index: int) -> CardSlotData:
	var slot_data = slot_datas[index]
	
	if slot_data: 
		return slot_data
	else:
		return null
	
func on_slot_clicked(index: int, button: int) -> void:
	card_interact.emit(self, index,button)
