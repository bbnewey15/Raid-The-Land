extends PanelContainer
class_name Slot

signal slot_clicked(index: int, button: int)
@onready var texture_rect = $MarginContainer/Control/%TextureRect
@onready var control_node = $MarginContainer/Control
@onready var unit_ui = $UnitUi
var slot_data : SlotData 
var unit_node : Node2D
var highlighted : bool = false

func _ready():
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)

func set_slot_data(data: SlotData) -> void:
	if unit_node:
		unit_node.queue_free()
		
	self.slot_data = data
	self.slot_data.current_slot = self
	
	slot_data.init_unit_data(slot_data.unit_data)
	#texture_rect.texture = unit_data.texture
	var unit_node_scene = load(slot_data.unit_data.unit_node_path)
	unit_node = unit_node_scene.instantiate()
	control_node.add_child(unit_node)
	if slot_data.isEnemyUnit:
		#flip the node 
		unit_node.apply_scale(Vector2(-1,1))
		#adjust for my shitty placement of anchor to unit
		unit_node.set_position(Vector2(unit_node.get_position().x + self.size.x, unit_node.get_position().y))
	tooltip_text = "%s\n%s" % [slot_data.unit_data.name, slot_data.unit_data.description]
	slot_data.set_slot_position(get_global_position() + size/2)
	
	# Update Unit UI
	unit_ui.set_unit_data(self.slot_data.unit_data)
	unit_ui.set_slot_data(self.slot_data)
	

func on_slot_data_changed():
	# Current way to update ui
	set_slot_data(slot_data)

	
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
	
	
func highlight_slot():
	highlighted = true
	self.set_self_modulate(Color(.3,.6, .7, .4))
	
func unhighlight_slot():
	highlighted = false
	self.set_self_modulate(Color(1, 1, 1, 0))
	

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

func defend(attackingUnit : SlotData) -> void:
	assert(attackingUnit)
	
	# Attacked animation
	var tween: Tween = create_tween()
	tween.tween_property(unit_node, "modulate:v", 1, 0.25).from(15)
	await tween.finished
	
	var damage_done = attackingUnit.unit_data.damage
	print("self.slot_data.unit_data.health - damage_done %s" % str(self.slot_data.unit_data.health - damage_done))
	var new_health = self.slot_data.unit_data.health - damage_done
	# Update unit datas new health
	self.slot_data.unit_data.update_health(new_health)
	# Update UI to show new health
	EncounterBus.slot_data_changed.emit()
	
	if new_health <= 0:
		self.die()
	

func die() -> void:
	
	
	# Attacked animation
	var tween: Tween = create_tween()

	# Add the animation to the Tween
	tween.tween_property(unit_node, "rotation_degrees", 90, 1)
	await tween.finished

func highlight_unit() -> void:
	print("highlighting")
	var tween: Tween = create_tween()
	tween.tween_property(unit_node, "modulate:v", 1, 0.25).from(15)
	await tween.finished


