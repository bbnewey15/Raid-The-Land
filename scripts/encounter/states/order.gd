extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager


func enter(_msg := {}) -> void:
#	state_machine.encounter_manager.add_child(encounter_message)
	print("Entered Order")
	pass
	
func update(delta: float) -> void:
	

	# On 1 side's turn end 
	await EncounterBus.order_state_ended
	state_machine.transition_to("Fight")
	print("end order %s" % delta)
	
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# display start message
		pass
#		print("continue %s"  % delta)
	
func exit() -> void:
	print("leaving order state")
