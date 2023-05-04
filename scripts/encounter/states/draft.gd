extends State

# use 'state_machine' to access state machine

func enter(_msg := {}) -> void:
	print("Drafing State Entered")
	pass
	
func update(delta: float) -> void:
	
	# Decide whos turn it is
	
	# On 1 side's turn end 
	#state_machine.transition_to("Place")
	print("end draft %s" % delta)
	
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# display start message
		pass
#		print("continue %s"  % delta)
