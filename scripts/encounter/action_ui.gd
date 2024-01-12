extends PanelContainer
class_name ActionUI

var currentUnit: UnitDataTest
#var active_slot_data : SlotData
var encounter_manager : EncounterManager


@onready var unit_actions = %UnitActions
@onready var actions = %Actions
@onready var action_scene = preload("res://scenes/encounter/actions/action.tscn")
@export var allowed_states : Array[String] = [GameData.FIGHT, GameData.POST_FIGHT]

func _ready():
	
	UiManager.register_ui_module(self as ActionUI)

	EncounterBus.unit_selected.connect(self.on_unit_selected)
	EncounterBus.action_request_ui.connect(self.on_action_request_ui)
	EncounterBus.ui_active_slot_data_changed.connect(self.update_actionUI)
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	EncounterBus.unit_turn_ended.connect(self.on_unit_turn_ended)
	
	for child in actions.get_children():
		child.queue_free()
	
func add_action(action_data: ActionData):
	var action_node = action_scene.instantiate()
	actions.add_child(action_node)
	action_node.action_selected.connect(self.on_action_selected)
	action_node.set_action_data(action_data)
	

	
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
			
			#EncounterBus.action_request_ui.emit(slot_data.current_slot)
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
	#self.update_actionUI()
		
func on_action_request_ui(slot: Slot):
	
	
	if GameData.ui_active_slot_data.action_set:
		self.get_potential_targets_and_emit(slot.slot_data.action_data)
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			self.show()
			self.update_actionUI()
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
				self.update_active_action_button(GameData.ui_active_slot_data.action_data)
				
				# Remove old actions
				for child in actions.get_children():
					child.queue_free()
				# Create actions
				for action in actions_available:
					self.add_action(action)
					
				
				unit_actions.show()
			else:
				self.update_active_action_button(null)
				self.hide()
		"PostFight":
			if GameData.ui_active_slot_data and !GameData.ui_active_slot_data.isEnemyUnit:
				self.show()
				unit_actions.hide()
			else:
				self.hide()
		_:
			unit_actions.hide()
			self.hide()
			
			
	

func on_action_selected(action_data: ActionData):
	assert(GameData.ui_active_slot_data)
	
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
	# Update UnitActions buttons to active action
	self.update_active_action_button(action_data)
	# Emit Action
	self.get_potential_targets_and_emit(action_data)
			
func get_potential_targets_and_emit(action_data: ActionData):
	#assert(GameData.UNIT_ACTIONS.values().has(action_data))
	assert(GameData.ui_active_slot_data)
	
	# If requires target, request a target
	if action_data.requires_target:
		
		# Get available targets 
		var potential_targets : Array[SlotData] = encounter_manager.columnGroup \
		.get_potential_action_targets(GameData.ui_active_slot_data, GameData.ui_active_slot_data.action_data)
		
		if len(potential_targets) > 0:
			# Following Signal Uses GameData.ui_active_slot_data
			EncounterBus.request_user_target_unit.emit(action_data, potential_targets)
			
		else:
			# Display message to user
			print("No available targets")


func update_active_action_button(action_data: ActionData):
	# Clear all
	self.unactive_all()
	
	if action_data == null:
		return
		
	if GameData.ui_active_slot_data and GameData.ui_active_slot_data.action_set:
		self.unactive_all()
		#ActionManager.set_active_action(action_data)
		for action in actions.get_children():
			if action == GameData.ui_active_slot_data.action_data:
				action.get_node("ColorRect").show()
		

func on_encounter_state_changed(state_name: String):
	if state_name != GameData.FIGHT:
		GameData.set_ui_active_slot_data(null)
		EncounterBus.end_request_user_target_unit.emit()
	
func unactive_all():
	for action in actions.get_children():
		action.get_node("ColorRect").hide()
	
