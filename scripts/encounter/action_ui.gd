extends PanelContainer
class_name ActionUI

var currentUnit: UnitDataTest
var active_slot_data : SlotData
var encounter_manager : EncounterManager
@onready var move_actions = %MoveActions
@onready var unit_actions = %UnitActions

func _ready():
	EncounterBus.unit_selected.connect(self.on_unit_selected)
	EncounterBus.action_request_ui.connect(self.on_action_request_ui)
	

func move_unit(direction: GameData.MOVE_DIRECTION ):
	print("direction" )
	print(direction)
	var slot = active_slot_data.current_slot
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
		column_moved_to.add_slot(active_slot_data, false)
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
	
	

func on_unit_selected(unit_col_data: UnitColumnData, index: int, colIndex: int, button: int) -> void:
	print("%s \n index: %s\n colIndex: %s\n %s" % [unit_col_data, index,colIndex, button])
	active_slot_data = null
	match [active_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			active_slot_data = unit_col_data.grab_slot_data(index)	
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			pass
		"PostFight":
			self.update_actionUI()
			active_slot_data.current_slot.highlight_unit()
		_:
			print("default")
			
		
func on_action_request_ui(slot: Slot):
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			pass
		"Order":
			active_slot_data = slot.slot_data
			self.update_actionUI()
		"PostFight":
			pass
		_:
			print("default")
	pass
	
	
	
func update_actionUI() -> void:
	match encounter_manager.encounterStateMachine.get_state_name():
		"Order":
			if active_slot_data:
				self.show()
				move_actions.hide()
				unit_actions.show()
			else:
				self.hide()
		"PostFight":
			if active_slot_data:
				self.show()
				move_actions.show()
				unit_actions.hide()
			else:
				self.hide()
		_:
			move_actions.hide()
			unit_actions.hide()
			self.hide()
			
			
	
