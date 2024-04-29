extends PanelContainer
class_name ActionUI

var currentUnit: UnitDataTest
var encounter_manager : EncounterManager


@export var allowed_states : Array[String] = [GameData.FIGHT, GameData.POST_FIGHT]

func _ready():
	self.hide()
	UiManager.register_ui_module(self as ActionUI)

	EncounterBus.unit_selected.connect(self.on_unit_selected)
	EncounterBus.action_request_ui.connect(self.on_action_request_ui)
	EncounterBus.ui_active_slot_data_changed.connect(self.update_actionUI)
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	EncounterBus.unit_turn_ended.connect(self.on_unit_turn_ended)
	EncounterBus.card_played.connect(self.on_action_selected)
	
		

	
func on_unit_selected(slot_data: SlotData, button: int) -> void:
	# Actions are only performed from ally units
	if slot_data.isEnemyUnit == true:
		if !GameData.debug_mode:
			return

	
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			# Update Self and UI (Targeter)
			# GameData.ui_active_slot_data will update in action_request_ui
			EncounterBus.action_request_ui.emit(slot_data.current_slot)
			pass
		"PostFight":
			match [GameData.ui_active_slot_data, button]:
				[null, MOUSE_BUTTON_LEFT]:
					GameData.set_ui_active_slot_data(slot_data)	
					self.update_actionUI()
		_:
			print("default")
			
func on_unit_turn_ended(slot_data: SlotData):
	self.hide()
		
func on_action_request_ui(slot: Slot):
	
	
#	if GameData.ui_active_slot_data.action_set:
#		self.get_potential_targets_and_emit(slot.slot_data.action_data)
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			self.show()
			pass
		"PostFight":
			pass
		_:
			print("default")
	
	
	
func update_actionUI() -> void:
	match encounter_manager.encounterStateMachine.get_state_name():
		"Fight":
			
			
			if GameData.ui_active_slot_data and !GameData.ui_active_slot_data.isEnemyUnit:
				# Get available actions for unit
				var unit_data = GameData.ui_active_slot_data.unit_data
				var actions_available = unit_data.action_manager.actions_available
				
			else:
				self.hide()
		"PostFight":
			if GameData.ui_active_slot_data and !GameData.ui_active_slot_data.isEnemyUnit:
				self.show()
				#unit_actions.hide()
			else:
				self.hide()
		_:
			#unit_actions.hide()
			self.hide()
			
			
	

func on_action_selected(card_slot: CardSlot):
	var action_data: ActionData = card_slot.slot_data.card_data.action_data
	assert(action_data)
	assert(GameData.ui_active_slot_data)
	
	# Determine if actions points available
	if GameData.ui_active_slot_data.unit_data.action_points < card_slot.slot_data.card_data.action_data.ap_cost:
		card_slot.show_insufficient_ap()
		return
	
	# If previous action required targets and this one doesnt
	EncounterBus.end_request_user_target_unit.emit()
	# Set active slot's data
	
	# if action already set and different action is selected
	if GameData.ui_active_slot_data.action_set and action_data != GameData.ui_active_slot_data.action_data:
		# Reset targets
		GameData.ui_active_slot_data.action_targets = []
	
	GameData.ui_active_slot_data.action_set = true
	GameData.ui_active_slot_data.action_data = action_data
	EncounterBus.slot_data_changed.emit()
	# Emit Action
	self.get_potential_targets_and_emit(card_slot)
			
func get_potential_targets_and_emit(card_slot: CardSlot):
	var action_data: ActionData = card_slot.slot_data.card_data.action_data
	assert(action_data)
	#assert(GameData.UNIT_ACTIONS.values().has(action_data))
	assert(GameData.ui_active_slot_data)
	
	# If requires target, request a target
	if action_data.requires_target:
		
		# Get available targets 
		var potential_targets : Array[SlotData] = encounter_manager.columnGroup \
		.get_potential_action_targets(GameData.ui_active_slot_data, GameData.ui_active_slot_data.action_data)
		
		if len(potential_targets) > 0:
			# Following Signal Uses GameData.ui_active_slot_data
			EncounterBus.request_user_target_unit.emit(card_slot, potential_targets)
			
		else:
			# Display message to user
			print("No available targets")


		

func on_encounter_state_changed(state_name: String):
	if state_name != GameData.FIGHT:
		GameData.set_ui_active_slot_data(null)
		EncounterBus.end_request_user_target_unit.emit()
	
	
