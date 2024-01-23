extends Node

var ui_modules : Array[Dictionary] = []

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
		if state_name in module["ui_module"].allowed_states:
			if module["show_on_start"]:
				module["ui_module"].show()
		else:
			module["ui_module"].hide()
		
func register_ui_module(ui_module: Node, show_on_start : bool = false):
	assert(ui_module)
	# Ensure module has required params
	assert(ui_module.allowed_states)
	
	self.ui_modules.append({"ui_module": ui_module, "show_on_start": show_on_start })
