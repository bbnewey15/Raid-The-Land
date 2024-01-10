extends State

# use 'state_machine' to access state machine

func enter(_msg := {}) -> void:
	print("-- DRAFT ENTERED --")
	EncounterBus.draft_state_started.emit()
	await EncounterBus.draft_state_ended
	print("-- TRANISITION TO Fight --")
	state_machine.transition_to("Fight")
	
func update(delta: float) -> void:
	
	EncounterBus.draft_state_ended.emit()
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# display start message
		pass
#		print("continue %s"  % delta)
func exit() -> void:
	print("-- DRAFT EXITED --")
