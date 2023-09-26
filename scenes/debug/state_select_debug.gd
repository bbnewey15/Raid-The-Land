extends Control
class_name DebugStatePicker

@onready var enable_enemy = %enableEnemy

var encounter_manager : EncounterManager
var current_state : String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_line_edit_text_submitted(new_text):
	print("DEBUG: ATTEMPTING TO TRANSITION STATE TO %s" % new_text)
	encounter_manager.encounterStateMachine.transition_to(new_text)



func _on_enable_enemy_pressed():
	var old_value = GameData.acting_as_enemy
	GameData.acting_as_enemy = !old_value
