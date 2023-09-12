extends PanelContainer
class_name ActionUI

var currentUnit: UnitDataTest
var active_slot_data : SlotData
var encounter_manager : EncounterManager

func _ready():
	EncounterBus.unit_selected.connect(self.on_unit_selected)
	

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
			update_actionUI()
			active_slot_data.current_slot.highlight_unit()
		_:
			print("default")
			
		
	
	
	
func update_actionUI() -> void:
	print("ACTION UI")
	if active_slot_data:
		self.show()
	else:
		self.hide()
