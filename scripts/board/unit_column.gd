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



func init(isEnemyParam: bool, column_type: GameData.COLUMN_TYPE) -> UnitColumn:
	self.isEnemy = isEnemyParam
	self.column_type = column_type
	EncounterBus.column_attacked.connect(Callable(self, "on_column_attacked"))
	EncounterBus.debug_ui.connect(self.debug_column_ui)
	EncounterBus.encounter_state_changed.connect(Callable(self,"on_encounter_state_changed"))
	return self
	
func _ready():
	encounter_manager = get_node("../..")
	assert(encounter_manager)
	pass

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
	data.attack_order = encounter_manager.columnGroup.get_next_attack_order(data.isEnemyUnit)
	# Rotate slot so it is on the right angle
	slot.set_pivot_offset(slot.size/2)
	#slot.set_rotation_degrees(-self.get_rotation_degrees())
	
	
	slot.set_slot_data(data)
	column_data.slot_datas.append(data)
	
	# Add slot clicked signal
	slot.slot_clicked.connect(column_data.on_slot_clicked)
#		print("is valid %s" %  column_data.on_slot_clicked.is_valid())
#		print("is connected? %s" % slot.is_connected("slot_clicked", column_data.on_slot_clicked))
#		print("has signal %s" % slot.has_signal("slot_clicked"))
#		print(slot.slot_clicked.get_connections())
	
	var parent  = get_parent_control()
		
	
	#slot.slot_clicked.connect(parent.)
	return slot
	
func _on_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Card Slot Clicked %s" % event )
			# Have to update position
			if highlighted:
				EncounterBus.column_clicked.emit(self, get_index(), event.button_index)

	
func on_encounter_state_changed(state_name):
	match state_name:
#		"Start":
#		"Fight":
#		"Place":
#		"Order":
		_:
			self.unhighlight_column()
			pass
	
func on_column_attacked(unit_column: UnitColumn, unit_attacking: SlotData)-> void:
	# Check if this is the column:
	if self.column_data.colIndex != unit_column.column_data.colIndex:
		return
		
	# Get slots in column
	for child in unit_column.unit_grid.get_children():
		child.defend(unit_attacking)
	
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
