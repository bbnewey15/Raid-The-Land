extends MarginContainer

@onready var perk_item_container = %PerkItemContainer
const perk_item_scene = preload("res://scenes/encounter/action_ui/perk_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	EncounterBus.ui_active_slot_data_changed.connect(self.on_ui_active_slot_data_changed)
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	for child in perk_item_container.get_children():
		child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_ui_active_slot_data_changed():
	if !GameData.ui_active_slot_data:
		return
	assert(GameData.ui_active_slot_data)
	
	# build perks
	self.build_perks(GameData.ui_active_slot_data)

func on_slot_data_changed():
	if !GameData.ui_active_slot_data:
		return
	assert(GameData.ui_active_slot_data)
	
	# build perks
	self.build_perks(GameData.ui_active_slot_data)
	
func build_perks(slot_data: SlotData):
	for child in perk_item_container.get_children():
		child.queue_free()
		
	var all_perks = slot_data.unit_data.perk_list
	for perk_data in all_perks:
		var perk_item = perk_item_scene.instantiate()
		self.perk_item_container.add_child(perk_item)
		perk_item.initialize(perk_data)
		
