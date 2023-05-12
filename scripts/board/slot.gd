extends PanelContainer
class_name Slot

signal slot_clicked(index: int, button: int)
@onready var texture_rect = $MarginContainer/Control/%TextureRect
@onready var control_node = $MarginContainer/Control

var slot_data : SlotData 
var unit_node : Node2D

func set_slot_data(slot_data: SlotData) -> void:
	if unit_node:
		unit_node.queue_free()
		
	self.slot_data = slot_data
	self.slot_data.current_slot = self
	var unit_data = slot_data.unit_data
	#texture_rect.texture = unit_data.texture
	var unit_node_scene = load(unit_data.unit_node_path)
	unit_node = unit_node_scene.instantiate()
	control_node.add_child(unit_node)
	if slot_data.isEnemyUnit:
		#flip the node 
		unit_node.apply_scale(Vector2(-1,1))
		#adjust for my shitty placement of anchor to unit
		unit_node.set_position(Vector2(unit_node.get_position().x + self.size.x, unit_node.get_position().y))
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

func attack(targetColumn : UnitColumn):
	# show animation, sound, update in data
	var animation_player : AnimationPlayer = unit_node.get_node("AnimationPlayer")
	animation_player.play("attack",-1,3)
	await animation_player.animation_finished
	
	EncounterBus.column_attacked.emit(targetColumn,slot_data)
	
	# 		is self dead? 
	# 		//show animation, sound, update in data
	
	await get_tree().create_timer(1.0).timeout

	
	# let EncounterBus know that we are done attacking
	EncounterBus.unit_attack_finished.emit(slot_data)
