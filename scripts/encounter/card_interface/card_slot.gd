class_name CardSlot extends PanelContainer

@onready var card_image = %CardImage
@onready var hand_ui = $CardUi
var unit_node : Node2D
var slot_data : CardSlotData 
var highlighted : bool = false

func set_slot_data(data: CardSlotData) -> void:
	if unit_node:
		unit_node.queue_free()

	self.slot_data = data

#	slot_data.init_card_data(slot_data.card_data)
	card_image.texture = slot_data.card_data.texture
#	var unit_node_scene = load(slot_data.card_data.unit_node_path)
#	unit_node = unit_node_scene.instantiate()
#	control_node.add_child(unit_node)

	tooltip_text = "%s\n%s" % [slot_data.card_data.name, slot_data.card_data.description]
	slot_data.set_slot_position(get_global_position() + size/2)

	# Update Hand UI
	hand_ui.card_slot = self as CardSlot
	hand_ui.loaded = true


func _process(delta):
	pass

func _on_gui_input(event):
	assert(slot_data)
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Card Slot Clicked %s" % event )
			# Have to update position
			slot_data.set_slot_position(get_global_position() + size/2)
			if highlighted:
				EncounterBus.card_played.emit(self)
			else:
				EncounterBus.card_slot_clicked.emit(self)
#			print(slot_clicked.get_connections())

func _on_mouse_entered():
	print("Card Slot Entered")
	pass # Replace with function body.

func setHighlight(shouldHighlight: bool)-> void:
	if shouldHighlight:
		highlighted = true
		set_position(Vector2(position.x, position.y - 15))
	else:
		highlighted = false
		set_position(Vector2(position.x, position.y + 15))


			
