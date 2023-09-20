extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager

const EncounerStartMessage = preload("res://scenes/encounter/encounter_start_message.tscn")
var encounter_message

func enter(_msg := {}) -> void:
	encounter_message = EncounerStartMessage.instantiate()
	state_machine.encounter_manager.add_child(encounter_message)
	print("-- START ENTERED --")
	await get_tree().create_timer(GameData.START_STATE_INTRO_TIMEOUT).timeout
	state_machine.transition_to("Draft")
	print("-- TRANSITION TO DRAFT --")
	pass
	
func update(delta: float) -> void:
	
	
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# display start message
		pass
#		print("continue %s"  % delta)
	
func exit() -> void:
	print("-- START EXITED --")
	encounter_message.queue_free()
