extends PanelContainer

signal slot_clicked(index: int, button: int)
@onready var texture_rect = $MarginContainer/Control/%TextureRect

var slot_data : SlotData 

func set_slot_data(slot_data: SlotData) -> void:
	self.slot_data = slot_data
	var unit_data = slot_data.unit_data
	texture_rect.texture = unit_data.texture
	tooltip_text = "%s\n%s" % [unit_data.name, unit_data.description]
	slot_data.set_slot_position(get_global_position() + size/2)

	
func _process(delta):
	pass
	
func _on_gui_input(event):
	
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Slot Clicked %s" % event )
			# Have to update position
			slot_data.set_slot_position(get_global_position() + size/2)
			slot_clicked.emit(get_index(), event.button_index)
#			print(slot_clicked.get_connections())

func _on_mouse_entered():
	print("Entered")
	pass # Replace with function body.


