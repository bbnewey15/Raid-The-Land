class_name UnitColumn
extends PanelContainer


const Slot = preload("res://scenes/slot.tscn")
@export var column_type: GameData.COLUMN_TYPE
var isEnemy: bool
@onready var unit_grid = $MarginContainer/%UnitGrid
var column_data: UnitColumnData

func init(isEnemyParam: bool, column_type: GameData.COLUMN_TYPE) -> UnitColumn:
	self.isEnemy = isEnemyParam
	self.column_type = column_type
	EncounterBus.column_attacked.connect(Callable(self, "on_column_attacked"))
	return self
	
func _ready():
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
		add_slot(slot_data)
			
	# set pivot point for proper rotation
	self.set_pivot_offset(size/2)
	# set size to all column
	self.set_size(GameData.COLUMN_SIZE)
	
func add_slot(data: SlotData) -> void:
	var slot = Slot.instantiate()
		
	unit_grid.add_child(slot)
	
	# Rotate slot so it is on the right angle
	var slot_text_rect : TextureRect = slot.get_node("MarginContainer/Control/%TextureRect")
	slot_text_rect.set_pivot_offset(slot.size/2)
	slot_text_rect.set_rotation_degrees(-self.get_rotation_degrees())
	
	
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
	
func on_column_attacked(unit_column: UnitColumn, unit_attacking: SlotData)-> void:
	# Check if this is the column:
	if self.column_data.colIndex != unit_column.column_data.colIndex:
		return
		
	# Get slots in column
	for child in unit_column.unit_grid.get_children():
		child.defend(unit_attacking)
	
