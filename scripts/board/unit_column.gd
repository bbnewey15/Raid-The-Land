class_name UnitColumn
extends PanelContainer

const Slot = preload("res://scenes/slot.tscn")
#Debug 
var DebugStatePicker = load("res://scenes/debug/state_select_debug.tscn")


@export var column_type: GameData.COLUMN_TYPE
var isEnemy: bool
@onready var unit_grid = $MarginContainer/%UnitGrid
var column_data: UnitColumnData
var encounter_manager : EncounterManager = null
var highlighted : bool = false
var col_position: Vector2


func init(isEnemyParam: bool, column_type: GameData.COLUMN_TYPE, position: Vector2) -> UnitColumn:
	self.isEnemy = isEnemyParam
	self.column_type = column_type
	EncounterBus.debug_ui.connect(self.debug_column_ui)
	EncounterBus.encounter_state_changed.connect(Callable(self,"on_encounter_state_changed"))
	
	self.col_position = position
	return self
	
func _ready():
	encounter_manager = get_node("../..")
	assert(encounter_manager)
	
	# set position
	if col_position:
		self.set_position(col_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_is_enemy(value: bool) -> void:
	self.isEnemy = value
	

# self must be in tree to run load_from_resource
func load_from_resource(data: UnitColumnData) -> void:
	# i think we have to save it otherwise it gets removed? and the signal no longer works
	column_data= data
	
	
	for child in unit_grid.get_children():
			child.queue_free()
			
	for slot_data in column_data.slot_datas:
		add_slot(slot_data, false)
			
	# set pivot point for proper rotation
	self.set_pivot_offset(size/2)
	# set size to all column
	self.set_size(GameData.COLUMN_SIZE)
	
	
	
	
func add_slot(data: SlotData, shouldUpdateUI: bool = true) -> Slot:
	var slot = Slot.instantiate()
	
	unit_grid.add_child(slot)
	
	data.slotIndex = slot.get_index()
	# action order will be set later
	# Rotate slot so it is on the right angle
	slot.set_pivot_offset(slot.size/2)
	#slot.set_rotation_degrees(-self.get_rotation_degrees())
	
	
	slot.set_slot_data(data)
	column_data.slot_datas.append(data)
	
	var parent  = get_parent_control()
		
	
	#slot.slot_clicked.connect(parent.)
	return slot
	
func _on_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Column Clicked %s" % event )
			# Have to update position
			if highlighted:
				# 1 because of target node is adding to index
				EncounterBus.column_clicked.emit(self, get_index()-1, event.button_index)

	
func on_encounter_state_changed(state_name):
	match state_name:
#		"Start":
#		"Fight":
		_:
			self.unhighlight_column()
			pass
	
func highlight_column():
	highlighted = true
	self.set_self_modulate(Color(.3,.6, .7, .4))
	
func unhighlight_column():
	highlighted = false
	self.set_self_modulate(Color(1, 1, 1, 0))
	
	
func debug_column_ui(debug: bool)-> void:
	self.highlight_column()
	
	# Instance State picker
	var statePicker = DebugStatePicker.instantiate()
	encounter_manager.add_child(statePicker)
	statePicker.encounter_manager = self.encounter_manager as EncounterManager
