extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager


func enter(_msg := {}) -> void:
#	state_machine.encounter_manager.add_child(encounter_message)
	print("Entered Post Fight")
	pass
	
func update(delta: float) -> void:
	

	#state_machine.transition_to("Draft")
	#print("end fight %s" % delta)
	
	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		pass
#		print("continue %s"  % delta)
	
	
func exit() -> void:
	print("leaving post fight state")


