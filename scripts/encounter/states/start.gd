extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager
var timer_started : bool = false
const EncounerStartMessage = preload("res://scenes/encounter/encounter_start_message.tscn")
var encounter_message

func enter(_msg := {}) -> void:
	encounter_message = EncounerStartMessage.instantiate()
	state_machine.encounter_manager.add_child(encounter_message)
	print("Entered start")
	pass
	
func update(delta: float) -> void:
	
	if timer_started == false:
		timer_started = true
		await get_tree().create_timer(GameData.START_STATE_INTRO_TIMEOUT).timeout
		state_machine.transition_to("Draft")
		print("end start %s" % delta)
	
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# display start message
		pass
#		print("continue %s"  % delta)
	
func exit() -> void:
	print("freeing message")
	encounter_message.queue_free()
