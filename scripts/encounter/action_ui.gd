extends PanelContainer
class_name ActionUI

var currentUnit: UnitDataTest
#var active_slot_data : SlotData
var encounter_manager : EncounterManager
@onready var move_actions = %MoveActions
@onready var unit_actions = %UnitActions

func _ready():
	EncounterBus.unit_selected.connect(self.on_unit_selected)
	EncounterBus.action_request_ui.connect(self.on_action_request_ui)
	

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
	
	
func on_unit_selected(slot_data: SlotData, index: int, button: int) -> void:
	# Actions are only performed from ally units
	if slot_data.isEnemyUnit == true:
		return
		
	print("index: %s\n %s" % [index, button])
	
	
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			pass
		"Order":
			# Update Self and UI (Highlighters)
			# GameData.ui_active_slot_data will update in action_request_ui
			EncounterBus.action_request_ui.emit(slot_data.current_slot)
			pass
		"PostFight":
			if GameData.ui_active_slot_data:
				assert(GameData.ui_active_slot_data)
				GameData.ui_active_slot_data.current_slot.highlighter.unhighlight_slot()
				GameData.ui_active_slot_data = null
			match [GameData.ui_active_slot_data, button]:
				[null, MOUSE_BUTTON_LEFT]:
					GameData.ui_active_slot_data = slot_data	
					self.update_actionUI()
					#GameData.ui_active_slot_data.current_slot.highlighter.highlight_slot()
		_:
			print("default")
			
		
func on_action_request_ui(slot: Slot):
	if GameData.ui_active_slot_data:
		assert(GameData.ui_active_slot_data)
		if GameData.ui_active_slot_data != slot.slot_data:
			GameData.ui_active_slot_data.current_slot.highlighter.unhighlight_slot()
			GameData.ui_active_slot_data = null
			EncounterBus.end_request_user_target_unit.emit()
	
	assert(slot)
	GameData.ui_active_slot_data = slot.slot_data
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			pass
		"Order":
			self.update_actionUI()
			GameData.ui_active_slot_data.current_slot.highlighter.highlight_slot()
		"PostFight":
			pass
		_:
			print("default")
	
	
	
func update_actionUI() -> void:
	match encounter_manager.encounterStateMachine.get_state_name():
		"Order":
			if GameData.ui_active_slot_data:
				self.show()
				move_actions.hide()
				unit_actions.show()
			else:
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
			self.get_potential_targets_and_emit(action)
			
func get_potential_targets_and_emit(action: GameData.UNIT_ACTIONS):
	# If requires target, request a target
	if GameData.ui_active_slot_data.unit_data.requires_target(action):
		# Get available targets 
		var potential_targets : Array[SlotData] = encounter_manager.columnGroup.get_potential_attack_targets(GameData.ui_active_slot_data)
		
		if len(potential_targets) > 0:
			# Following Signal Uses GameData.ui_active_slot_data
			EncounterBus.request_user_target_unit.emit(action, potential_targets)
			
		else:
			# Display message to user
			print("No available targets")
