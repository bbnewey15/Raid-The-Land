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
	
	# action weight
	var attack_weight : int = 8
	var debuff_weight : int = 4
	var heal_weight : int = 4
	
	# What questions should the AI ask?
	# Do I have low health?
	var percentage_health : float = float(slot_data.unit_data.health) / slot_data.unit_data.max_health
	
	if percentage_health > 0 and percentage_health < .33:
		heal_weight = 8
	if percentage_health >= .34 and percentage_health < .66:
		heal_weight = 5
	if percentage_health >= .67 and percentage_health < 1:
		heal_weight = 2
		
	# Does the enemy have low health?
	var player_slots = GameData.full_slot_array.filter(func(x): return !x.isEnemyUnit)
	for player_slot_data in player_slots:
		var tmp_health_percentage : float = float(player_slot_data.unit_data.health) / player_slot_data.unit_data.max_health
		if tmp_health_percentage > 0 and tmp_health_percentage < .33:
			attack_weight = 15 if attack_weight < 15 else attack_weight
		if percentage_health >= .34 and percentage_health < .66:
			attack_weight = 10 if attack_weight < 10 else attack_weight
		if percentage_health >= .67 and percentage_health < 1:
			attack_weight = 5 if attack_weight < 5 else attack_weight
	
	# Do I already have these stacks/buffs applied
	var conditions : Array[ConditionData] = slot_data.unit_data.conditions
	for condition_data in conditions:
		if condition_data.condition == GameData.CONDITIONS.HEAL and condition_data.stacks > 1:
			heal_weight = 3
		if condition_data.condition == GameData.CONDITIONS.HEAL and condition_data.stacks > 2:
			heal_weight = 1
		
	if len(conditions) > 1:
		debuff_weight = 3
	if len(conditions) > 2:
		debuff_weight = 2
	
	print("Unit %s action weight: Attack weight [%s] | Heal weight [%s] | Debuff Player [%s]" % [slot_data.unit_data.name, attack_weight, heal_weight, debuff_weight])
	
	var action_data = slot_data.unit_data.action_manager.get_random_action_by_weight(filter_for_actions, attack_weight, debuff_weight, heal_weight )
	
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
