extends Node
class_name ActionManager

var actions_available : Array[ActionData] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_action_data(action_array: Array[ActionData]):
	assert(action_array)
	
	actions_available = action_array
	
func add_action(action_data : ActionData):
	actions_available.append(action_data);
	
func remove_action(action_data : ActionData):
	var idx_to_remove = actions_available.find(action_data)
	actions_available.remove_at(idx_to_remove)

func get_random_action_by_weight(filter, action_weight: int, debuff_weight: int, heal_weight: int):
	var total_weight = action_weight + debuff_weight + heal_weight
	
	var a = func roll():
		var rng = RandomNumberGenerator.new()
		var rand = rng.randf_range(0, total_weight)
		
		var action_to_use : GameData.UNIT_ACTIONS
		
		if rand > 0 and rand <= action_weight:
			action_to_use = GameData.UNIT_ACTIONS.ATTACK
		if rand > action_weight and rand <= action_weight + debuff_weight:
			action_to_use = GameData.UNIT_ACTIONS.DEBUFF
		if rand > action_weight + debuff_weight and rand <= total_weight:
			action_to_use = GameData.UNIT_ACTIONS.SUPPORT
		return action_to_use
		
	
	var action_found = false
	var action : ActionData
	var counter : int = 0
	while !action_found and !counter > 5:
		counter += 1
		var action_type = a.call()
		print("Action chose %s" % action_type)
		var filtered_actions = actions_available.filter(filter) if filter else actions_available
		var similar_actions = filtered_actions.filter(func(x): return x.action_type == action_type)
		if len(similar_actions) > 0:
			action = similar_actions.pick_random()
			if action:
				action_found = true
				return action
	
	if action_found == false or action == null:
		push_warning("Action not selected by weight")
		var filtered_actions = actions_available.filter(filter) if filter else actions_available
		return filtered_actions.pick_random()
