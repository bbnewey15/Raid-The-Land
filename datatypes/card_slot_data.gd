class_name CardSlotData extends Resource

@export var card_data:  CardData


func init_card_data(data: CardData):
	if data:
		self.card_data = data
	else:
		card_data = card_data.duplicate(true)

var slot_position: Vector2

func set_slot_position(pos: Vector2)->void:
	slot_position = pos
