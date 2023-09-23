extends State

# use 'state_machine' to access state machine

func enter(_msg := {}) -> void:
	print("-- PLACE ENTERED --")
	EncounterBus.place_state_started.emit()
	await EncounterBus.place_state_ended
	print("-- TRANISITION TO ORDER --")
	state_machine.transition_to("Order")
	
func update(delta: float) -> void:
	
	# Decide whos turn it is
	
	# On 1 side's turn end 

	
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# display start message
		pass
#		print("continue %s"  % delta)

func exit() -> void:
	print("-- PLACE EXITED --")
