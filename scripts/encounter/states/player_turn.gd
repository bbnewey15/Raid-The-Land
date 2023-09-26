extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager

func enter(_msg := {}) -> void:
#	state_machine.encounter_manager.add_child(encounter_message)
	print("-- PLAYERTURN ENTERED --")
	EncounterBus.player_turn_state_started.emit()
	await EncounterBus.player_turn_state_stopped
	print("-- TRANISITION TO EnemyTurn --")
	state_machine.transition_to("EnemyTurn")
	
	
	pass
	
func update(delta: float) -> void:
	

	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# Stuff that still needs to run
		pass
	
func exit() -> void:
	print("-- PLAYER_TURN EXITED --")


