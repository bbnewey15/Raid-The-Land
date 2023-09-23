extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager


func enter(_msg := {}) -> void:
	print("-- POST FIGHT ENTERED --")
	EncounterBus.post_fight_state_started.emit()
	await EncounterBus.post_fight_state_ended
	print("-- TRANSITION TO DRAFT --")
	state_machine.transition_to("Draft")
	pass
	
func update(delta: float) -> void:
	

	#state_machine.transition_to("Draft")
	#print("end fight %s" % delta)
	
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		pass
#		print("continue %s"  % delta)
	
	
func exit() -> void:
	print("-- POST FIGHT EXITED --")


