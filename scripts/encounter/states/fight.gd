extends State

# use 'state_machine' to access state machine
# use 'state_machine.encounter_manager' to access Encounter Manager

func enter(_msg := {}) -> void:
#	state_machine.encounter_manager.add_child(encounter_message)
	print("-- FIGHT ENTERED --")
	EncounterBus.fight_state_started.emit()
#		print("start wait on fight")
	await EncounterBus.fight_state_stopped
	print("-- TRANSITION TO POST FIGHT --")
	state_machine.transition_to("PostFight")
	
	pass
	
func update(delta: float) -> void:
	

	#check here to prevent the last tick to hit after await
	if state_machine.state.name == self.name:
		# Stuff that still needs to run
		pass
	
func exit() -> void:
	print("-- FIGHT EXITED --")


#
#UnitColumnGroup on state: "fight"
#
#put units in order by attack order and turn priority
#
#for unit in units:
#
# target = get_attack_target(unit)
#
# unit.attack(target)
# //show animation, sound, update in data
#
# is target dead?
# is unit dead?
# //show animation, sound, update in data
#
#
#EncounterBus.fight_completed.emit()
