extends Control
class_name DebugStatePicker

var encounter_manager : EncounterManager
var current_state : String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_line_edit_text_submitted(new_text):
	print("DEBUG: ATTEMPTING TO TRANSITION STATE TO %s" % new_text)
	encounter_manager.encounterStateMachine.transition_to(new_text)
