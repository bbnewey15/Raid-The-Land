extends PanelContainer
class_name Slot

@onready var control_node = %UnitNode
@onready var unit_ui = %UnitUi

var slot_data : SlotData 
var unit_node : Node2D
var basic_attack_path = "res://scripts/encounter/actions/attacks/basic_attack.tres"
var heal_path = "res://scripts/encounter/actions/supports/heal_ally.tres"

func _ready():
	unit_ui.slot = self as Slot
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	
func initialize(slot_data: SlotData):
	
		
	self.slot_data = slot_data
	self.slot_data.current_slot = self
	slot_data.init_unit_data(slot_data.unit_data)
	
	if unit_node:
		unit_node.queue_free()
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

func set_slot_data(data: SlotData) -> void:
	
	# Update Unit UI
	unit_ui.set_unit_data(self.slot_data.unit_data)
	unit_ui.set_slot_data(self.slot_data)
	
	# set action manager 
	var action_manager = self.get_node("%ActionManager")
	var tmp_action_array : Array[ActionData]= []
	var attack_action = load(basic_attack_path).duplicate(true)
	var heal_action = load(heal_path).duplicate(true)
	tmp_action_array.append(attack_action)
	tmp_action_array.append(heal_action)
	
	action_manager.set_action_data(tmp_action_array)
	self.slot_data.unit_data.action_manager = action_manager
	
	
	

func on_slot_data_changed():
	# Current way to update ui
	self.set_slot_data(slot_data)
	
	
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

func unit_action(action_data: ActionData, target: SlotData):
	# reset targets
	EncounterBus.end_request_user_target_unit.emit()
	
	await self.unit_ui.action_displayer.display_action( action_data)
	
	var hit_value = GameData.ACTION_SLIDER_HIT.HIT
	# action slider - aka skill check to be removed 
#	if !slot_data.isEnemyUnit:
#		EncounterBus.action_slider_requested.emit(slot_data.action_data, slot_data, target)
#		hit_value = await EncounterBus.action_slider_completed
	
	match action_data.action_type:
		GameData.UNIT_ACTIONS.ATTACK:
			await self.attack(target, hit_value)
		GameData.UNIT_ACTIONS.DEBUFF:
			await self.attack(target, hit_value)
		GameData.UNIT_ACTIONS.DEFEND:
			await self.support(target)
		GameData.UNIT_ACTIONS.SUPPORT:
			await self.support(target)
		_:
			push_warning("Default value used in unit_data's requires_target")
			
	
	# Enemy
	if self.slot_data.isEnemyUnit:
		self.slot_data.turn_over = true
		EncounterBus.unit_turn_ended.emit(slot_data)
		return
	
	
	# end turn if AP is gone
	self.slot_data.unit_data.update_action_points(self.slot_data.unit_data.action_points - action_data.ap_cost)
	if self.slot_data.unit_data.action_points <= 0:
		self.slot_data.turn_over = true
		EncounterBus.unit_turn_ended.emit(slot_data)
	
	
	

func attack(defending_slot_data: SlotData, hit_value: GameData.ACTION_SLIDER_HIT):
	# show animation, sound, update in data
	var animation_player : AnimationPlayer = unit_node.get_node("AnimationPlayer")
	animation_player.play("attack",-1,3)
	#var a = await animation_player.animation_finished
	await get_tree().create_timer(.6).timeout
	#EncounterBus.slot_attacked.emit(self.slot_data, defending_slot_data)
	if hit_value == GameData.ACTION_SLIDER_HIT.MISS:
		await self.miss_action(defending_slot_data)
	else:
		await defending_slot_data.current_slot.receive_attack(self.slot_data as SlotData)
	

func receive_attack(attackingUnit : SlotData):
	assert(attackingUnit)
	
	# Attacked animation
	var tween: Tween = create_tween()
	tween.tween_property(unit_node, "modulate:v", 1, 0.25).from(15)
	await tween.finished
	
	var damage_done = attackingUnit.unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.DAMAGE).value
	
	# Check blocking
	var adj_damage_done = damage_done
#	if self.slot_data.action_data == GameData.UNIT_ACTIONS["DEFEND"]:
#		adj_damage_done = damage_done - ( damage_done * self.slot_data.unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.DEFEND).value )
	
	print("self.slot_data.unit_data.health - damage_done %s" % str(self.slot_data.unit_data.health - adj_damage_done))
	var new_health = self.slot_data.unit_data.health - adj_damage_done
	# Update unit datas new health
	var unit_data = self.slot_data.unit_data
	self.slot_data.unit_data.update_health(new_health)
	
	# Apply conditions
	if attackingUnit.action_data.apply_condition:
		self.apply_condition(attackingUnit.action_data, self.slot_data)
	
	if new_health <= 0:
		self.slot_data.unit_data.status =  GameData.UNIT_STATUS.DEAD
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
	#var a = await animation_player.animation_finished
	await get_tree().create_timer(.6).timeout
	await supporting_slot_data.current_slot.receive_support(self.slot_data as SlotData)
	
func receive_support(supporting_unit : SlotData):
	assert(supporting_unit)
	
	# Attacked animation
	var tween: Tween = create_tween()
	tween.tween_property(unit_node, "modulate:v", 1, 0.25).from(15)
	await tween.finished
	

	# Apply conditions
	if supporting_unit.action_data.apply_condition:
		self.apply_condition(supporting_unit.action_data, self.slot_data)

	# Update UI to show new health
	EncounterBus.slot_data_changed.emit()
	
func miss_action(target: SlotData):
	var animation_player : AnimationPlayer = unit_node.get_node("AnimationPlayer")
	animation_player.play("attack",-1,3)
	await self.unit_ui.action_displayer.display_custom("MISS!")
	
	await get_tree().create_timer(.6).timeout
	
func apply_condition(action_data: ActionData, slot_to_apply: SlotData):
	assert(action_data)
	assert(action_data.apply_condition)
	assert(slot_to_apply)
	
	# Add conditions
	for condition in action_data.conditions:
		slot_to_apply.unit_data.add_condition(condition.duplicate(true))
	
	# Trigger conditions for the first time, they will resolve at the start of their next turn
	slot_to_apply.current_slot.resolve_conditions()	

func resolve_conditions():
	if len(self.slot_data.unit_data.conditions) > 0:
		for condition in self.slot_data.unit_data.conditions:
			#TODO animate unit for condition
			await get_tree().create_timer(.6).timeout
			
			condition.execute(self.slot_data.unit_data)
			if condition.stacks <= 0:
				# Remove
				self.slot_data.unit_data.conditions.remove_at(self.slot_data.unit_data.conditions.find(condition))
				EncounterBus.slot_data_changed.emit()
				
			# TODO
			await get_tree().create_timer(.6).timeout

func die() -> void:
	
	
	# Attacked animation
	var tween: Tween = create_tween()

	# Add the animation to the Tween
	tween.tween_property(unit_node, "rotation_degrees", 90, 1)
	await tween.finished
	
	# Let order know to update order
	EncounterBus.request_recalculate_unit_order.emit()

func highlight_unit() -> void:
	print("highlighting")
	var tween: Tween = create_tween()
	tween.tween_property(unit_node, "modulate:v", 1, 0.25).from(15)
	await tween.finished





