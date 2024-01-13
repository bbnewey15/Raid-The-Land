extends MarginContainer

@onready var stat_item_container = %StatItemContainer
const stat_item_scene = preload("res://scenes/encounter/action_ui/stat_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	EncounterBus.ui_active_slot_data_changed.connect(self.on_ui_active_slot_data_changed)
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	for child in stat_item_container.get_children():
		child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_ui_active_slot_data_changed():
	if !GameData.ui_active_slot_data:
		return
	assert(GameData.ui_active_slot_data)
	
	# build stats
	self.build_stats(GameData.ui_active_slot_data)

func on_slot_data_changed():
	if !GameData.ui_active_slot_data:
		return
	assert(GameData.ui_active_slot_data)
	
	# build stats
	self.build_stats(GameData.ui_active_slot_data)
	
func build_stats(slot_data: SlotData):
	for child in stat_item_container.get_children():
		child.queue_free()
		
	var attributes = slot_data.unit_data.stat_data.getAttributes()
	for attribute in attributes:
		var stat_item = stat_item_scene.instantiate()
		self.stat_item_container.add_child(stat_item)
		stat_item.initialize(attribute)
		
