extends Control
class_name AiActionManager

var encounter_manager : EncounterManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EncounterBus.ai_action_request.connect(self.on_ai_action_request)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_ai_action_request(slot_data: SlotData):
	var actions_available : Array[ActionData] = slot_data.unit_data.action_manager.actions_available
	
	var filter_for_actions = func(action):
		var available = true
		# Are there targets available
		if action.requires_target:
			var potential_targets : Array[SlotData] = encounter_manager.columnGroup \
			.get_potential_action_targets(slot_data, action)
			
			if len(potential_targets) == 0:
				available = false
		
		return available
			
	
	# Which actions are actually usable
	var filtered_actions = actions_available.filter(filter_for_actions)
	
	var action_data = actions_available.pick_random()
	
	GameData.set_ui_active_slot_data(slot_data)
	GameData.ui_active_slot_data.action_set = true
	GameData.ui_active_slot_data.action_data = action_data
	EncounterBus.slot_data_changed.emit()
	
	# If requires target, request a target
	if action_data.requires_target:
		var action_targets : Array[SlotData]= []
		# Get available targets 
		var potential_targets : Array[SlotData] = encounter_manager.columnGroup \
		.get_potential_action_targets(slot_data, action_data)
		
		# Following Signal Uses GameData.ui_active_slot_data
		while len(action_targets) < action_data.number_of_targets and len(potential_targets) > 0:
			var temp = potential_targets.pick_random()
			var temp_idx = potential_targets.find(temp)
			action_targets.append(temp)
			potential_targets.remove_at(temp_idx)
			
			
		slot_data.action_targets = action_targets
			
	await get_tree().create_timer(1.5).timeout
	
	EncounterBus.action_activated.emit(GameData.ui_active_slot_data)
