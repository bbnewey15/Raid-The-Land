extends Node

var ui_modules : Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_encounter_state_changed(state_name : String) -> void:
	# Update UI Items based on state
	for module in self.ui_modules:
		if state_name in module.allowed_states:
			module.show()
		else:
			module.hide()
		
func register_ui_module(ui_module: Node):
	assert(ui_module)
	# Ensure module has required params
	assert(ui_module.allowed_states)
	
	self.ui_modules.append(ui_module)
