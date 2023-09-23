extends PanelContainer
class_name Slot

@onready var texture_rect = $MarginContainer/Control/%TextureRect
@onready var control_node = $MarginContainer/Control
@onready var unit_ui = $UnitUi
@onready var targeter = %Targeter
var slot_data : SlotData 
var unit_node : Node2D



func _ready():
	targeter.slot = self as Slot
	unit_ui.slot = self as Slot
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
	targeter.slot = self as Slot
	
func _process(delta):
	pass
	
func _on_gui_input(event):
	
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Slot Clicked %s" % event )
			# Have to update position
			slot_data.set_slot_position(get_global_position() + size/2)
			EncounterBus.unit_selected.emit(self.slot_data,event.button_index)

func _on_mouse_entered():
	EncounterBus.slot_hovered.emit(slot_data)
	print("Entered")
	pass # Replace with function body.

func _on_mouse_exited():
	EncounterBus.slot_hover_exited.emit(slot_data)
	pass # Replace with function body.

func unit_action(action: GameData.UNIT_ACTIONS, target):
	match action:
		GameData.UNIT_ACTIONS["ATTACK"]:
			await self.attack(target)
		GameData.UNIT_ACTIONS["DEFEND"]:
			await self.defend()
		GameData.UNIT_ACTIONS["SUPPORT"]:
			await self.support(target)
		_:
			push_warning("Default value used in unit_data's requires_target")

func attack(defending_slot_data: SlotData):
	# show animation, sound, update in data
	var animation_player : AnimationPlayer = unit_node.get_node("AnimationPlayer")
	animation_player.play("attack",-1,3)
	await animation_player.animation_finished
	
	#EncounterBus.slot_attacked.emit(self.slot_data, defending_slot_data)
	await defending_slot_data.current_slot.receive_attack(self.slot_data as SlotData)
	# 		is self dead? 
	# 		//show animation, sound, update in data
	
	#await get_tree().create_timer(1.0).timeout

	
	# let EncounterBus know that we are done attacking
	#EncounterBus.unit_attack_finished.emit(slot_data)
	

func receive_attack(attackingUnit : SlotData):
	assert(attackingUnit)
	
	# Attacked animation
	var tween: Tween = create_tween()
	tween.tween_property(unit_node, "modulate:v", 1, 0.25).from(15)
	await tween.finished
	
	var damage_done = attackingUnit.unit_data.damage
	
	# Check blocking
	var adj_damage_done = damage_done
	if self.slot_data.action == GameData.UNIT_ACTIONS["DEFEND"]:
		adj_damage_done = damage_done - ( damage_done * self.slot_data.unit_data.defend_ratio )
	
	print("self.slot_data.unit_data.health - damage_done %s" % str(self.slot_data.unit_data.health - adj_damage_done))
	var new_health = self.slot_data.unit_data.health - adj_damage_done
	# Update unit datas new health
	self.slot_data.unit_data.update_health(new_health)
	
	if new_health <= 0:
		self.die()
		
	# Update UI to show new health
	EncounterBus.slot_data_changed.emit()
	
func defend():
	# show animation, sound, update in data
	var animation_player : AnimationPlayer = unit_node.get_node("AnimationPlayer")
	animation_player.play("attack",-1,3)
	await animation_player.animation_finished
	

	
func support(supporting_slot_data: SlotData):
	# show animation, sound, update in data
	var animation_player : AnimationPlayer = unit_node.get_node("AnimationPlayer")
	animation_player.play("attack",-1,3)
	await animation_player.animation_finished
	
	await supporting_slot_data.current_slot.receive_support(self.slot_data as SlotData)
	
func receive_support(supporting_unit : SlotData):
	assert(supporting_unit)
	
	# Attacked animation
	var tween: Tween = create_tween()
	tween.tween_property(unit_node, "modulate:v", 1, 0.25).from(15)
	await tween.finished
	
	var healing_done = supporting_unit.unit_data.support_amount
	print("self.slot_data.unit_data.health - healing_done %s" % str(self.slot_data.unit_data.health - healing_done))
	var new_health = self.slot_data.unit_data.health + healing_done
	
	
	if new_health > self.slot_data.unit_data.max_health:
		new_health = self.slot_data.unit_data.max_health
		
	# Update unit datas new health
	self.slot_data.unit_data.update_health(new_health)
	# Update UI to show new health
	EncounterBus.slot_data_changed.emit()

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





