extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager

func enter(_msg := {}) -> void:
#	state_machine.encounter_manager.add_child(encounter_message)
	print("-- PLAYER_TURN ENTERED --")
	EncounterBus.enemy_turn_state_started.emit()
#		print("start wait on enemy_turn")
	await EncounterBus.enemy_turn_state_stopped
	print("-- TRANSITION TO POST FIGHT --")
	state_machine.transition_to("PostFight")
	
	pass
	
func update(delta: float) -> void:
	

	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# Stuff that still needs to run
		pass
	
func exit() -> void:
	print("-- ENEMY_TURN EXITED --")


