extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager

func enter(_msg := {}) -> void:
#	state_machine.encounter_manager.add_child(encounter_message)
	print("Entered Order")
	EncounterBus.order_state_started.emit()
	pass
	
func update(delta: float) -> void:
	
	await EncounterBus.order_state_ended
	state_machine.transition_to("Fight")
	print("fight stopped")
		
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# Stuff that still needs to run
		pass

	
func exit() -> void:
	print("leaving order state")
