extends State

# use 'state_machine' to access state machine

func enter(_msg := {}) -> void:
	print("Place State Entered")
	pass
	
func update(delta: float) -> void:
	
	# Decide whos turn it is
	
	# On 1 side's turn end 
	await EncounterBus.place_finished
	state_machine.transition_to("Fight")
	print("end place %s" % delta)
	
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# display start message
		pass
#		print("continue %s"  % delta)
