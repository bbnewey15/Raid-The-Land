extends State
var action_started : bool = false
# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager

func enter(_msg := {}) -> void:
#	state_machine.encounter_manager.add_child(encounter_message)
	print("-- ORDER ENTERED --")
	EncounterBus.order_state_started.emit()
	await EncounterBus.order_state_ended
	print("-- TRANISITION TO FIGHT --")
	state_machine.transition_to("Fight")
	
func update(delta: float) -> void:
	
	
	
		
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# Stuff that still needs to run
		pass

	
func exit() -> void:
	print("-- ORDER EXITED --")
