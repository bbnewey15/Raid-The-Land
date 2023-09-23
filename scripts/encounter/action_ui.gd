extends PanelContainer
class_name ActionUI

var currentUnit: UnitDataTest
#var active_slot_data : SlotData
var encounter_manager : EncounterManager
@onready var move_actions = %MoveActions
@onready var unit_actions = %UnitActions
@onready var attack_action = %AttackAction
@onready var defend_action = %DefendAction
@onready var support_action = %SupportAction

@export var allowed_states : Array[String] = [GameData.ORDER, GameData.POST_FIGHT]

func _ready():
	
	UiManager.register_ui_module(self as ActionUI)
	
	EncounterBus.unit_selected.connect(self.on_unit_selected)
	EncounterBus.action_request_ui.connect(self.on_action_request_ui)
	EncounterBus.ui_active_slot_data_changed.connect(self.update_actionUI)
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	
	

func move_unit(direction: GameData.MOVE_DIRECTION ):
	assert(GameData.ui_active_slot_data)
	
	print("direction" )
	print(direction)
	var slot = GameData.ui_active_slot_data.current_slot
	var moving_slot_column : UnitColumn = slot.get_node("../../../")
	var move_to_column_index
	match direction:
		GameData.LEFT:
			print("LEFT")
			
			move_to_column_index = moving_slot_column.column_data.colIndex - 1
			
		GameData.RIGHT:
			print("RIGHT")
			move_to_column_index = moving_slot_column.column_data.colIndex + 1
			
	assert(move_to_column_index != null)
	
	if move_to_column_index >= 0 && move_to_column_index <= 5:
		moving_slot_column.unit_grid.remove_child(slot)
		
		#Add to new column
		var column_moved_to: UnitColumn = encounter_manager.columnGroup.column_dict[GameData.getColumnStringByIndex(move_to_column_index)]
		column_moved_to.add_slot( GameData.ui_active_slot_data, false)
		update_actionUI()
		#Remove from old column
		slot.queue_free()
	else:
		return


func _on_move_gui_input(event, left_or_right):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Move Left Clicked %s : %s" % [event, left_or_right] )
			move_unit(left_or_right)
	
	
func on_unit_selected(slot_data: SlotData, button: int) -> void:
	# Actions are only performed from ally units
	if slot_data.isEnemyUnit == true:
		if !GameData.debug_mode:
			return

	
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			pass
		"Order":
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
			
		
func on_action_request_ui(slot: Slot):
	if GameData.ui_active_slot_data:
		assert(GameData.ui_active_slot_data)
		if GameData.ui_active_slot_data != slot.slot_data:
			GameData.set_ui_active_slot_data(null)
			EncounterBus.end_request_user_target_unit.emit()
			
			
	
	assert(slot)
	GameData.set_ui_active_slot_data(slot.slot_data)
	
	if GameData.ui_active_slot_data.action_set:
		self.get_potential_targets_and_emit(slot.slot_data.action)
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			pass
		"Order":
			self.update_actionUI()
		"PostFight":
			pass
		_:
			print("default")
	
	
	
func update_actionUI() -> void:
	match encounter_manager.encounterStateMachine.get_state_name():
		"Order":
			
			
			if GameData.ui_active_slot_data:
				self.update_active_action_button(GameData.ui_active_slot_data.action)
				self.show()
				move_actions.hide()
				unit_actions.show()
			else:
				self.update_active_action_button(0)
				self.hide()
		"PostFight":
			if GameData.ui_active_slot_data:
				self.show()
				move_actions.show()
				unit_actions.hide()
			else:
				self.hide()
		_:
			move_actions.hide()
			unit_actions.hide()
			self.hide()
			
			
	

func _on_action_gui_input(event, action: GameData.UNIT_ACTIONS):
	assert(GameData.ui_active_slot_data)
	
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			# If previous action required targets and this one doesnt
			EncounterBus.end_request_user_target_unit.emit()
			# Set active slot's data
			
			# if action already set and different action is selected
			if GameData.ui_active_slot_data.action_set and action != GameData.ui_active_slot_data.action:
				# Reset targets
				GameData.ui_active_slot_data.action_targets = []
			
			GameData.ui_active_slot_data.action_set = true
			GameData.ui_active_slot_data.action = action
			EncounterBus.slot_data_changed.emit()
			# Update UnitActions buttons to active action
			self.update_active_action_button(action)
			# Emit Action
			self.get_potential_targets_and_emit(action)
			
func get_potential_targets_and_emit(action: GameData.UNIT_ACTIONS):
	assert(GameData.UNIT_ACTIONS.values().has(action))
	assert(GameData.ui_active_slot_data)
	
	# If requires target, request a target
	if GameData.ui_active_slot_data.unit_data.requires_target(action):
		
		# Get available targets 
		var potential_targets : Array[SlotData] = encounter_manager.columnGroup \
		.get_potential_action_targets(GameData.ui_active_slot_data, GameData.ui_active_slot_data.action)
		
		if len(potential_targets) > 0:
			# Following Signal Uses GameData.ui_active_slot_data
			EncounterBus.request_user_target_unit.emit(action, potential_targets)
			
		else:
			# Display message to user
			print("No available targets")


func update_active_action_button(action: GameData.UNIT_ACTIONS):
	# Clear all
	self.unactive_all()
		
	if GameData.ui_active_slot_data and GameData.ui_active_slot_data.action_set:
		self.unactive_all()
		match action:
			GameData.UNIT_ACTIONS.ATTACK:
				attack_action.get_node("ColorRect").show()
			GameData.UNIT_ACTIONS.DEFEND:
				defend_action.get_node("ColorRect").show()
			GameData.UNIT_ACTIONS.SUPPORT:
				support_action.get_node("ColorRect").show()
		

func on_encounter_state_changed(state_name: String):
	if state_name != GameData.ORDER:
		GameData.set_ui_active_slot_data(null)
		EncounterBus.end_request_user_target_unit.emit()
	
func unactive_all():
	attack_action.get_node("ColorRect").hide()
	defend_action.get_node("ColorRect").hide()
	support_action.get_node("ColorRect").hide()
