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
