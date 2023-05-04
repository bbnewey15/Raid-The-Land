extends PanelContainer
class_name ActionUI

var currentUnit: UnitData
var active_slot_data : SlotData
var encounter_manager : EncounterManager

func _ready():
	EncounterBus.unit_selected.connect(self.on_unit_selected)
	

func move_unit(direction: GameData.MOVE_DIRECTION ):
	print("direction" )
	print(direction)
	match direction:
		GameData.LEFT:
			print("LEFT")
		GameData.RIGHT:
			print("RIGHT")
			
	#currentUnit.move_unit(direction)
	


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
		_:
			print("default")
			
		
	
	
	
func update_actionUI() -> void:
	print("ACTION UI")
	if active_slot_data:
		self.show()
		self.set_global_position(active_slot_data.slot_position - self.size/2, true)
	else:
		self.hide()
