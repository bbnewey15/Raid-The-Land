extends Control

@onready var panel_container = %PanelContainer
const panel_scene = preload("res://scenes/encounter/unit_ui/level_up_panel.tscn")
var slot : Slot

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	
	self.remove_child_panels()
		
	#connect to on_level_up_unit_request signal
	EncounterBus.level_up_request_ui.connect(self.on_level_up_unit_request)
	#EncounterBus.level_up_finished.connect(self.on_level_up_finished)
	
	#EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	

func initialize(slot: Slot):
	assert(slot)
	assert(slot.slot_data)
	self.slot = slot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_child_panels():
	for child in panel_container.get_children():
		child.queue_free()

func on_level_up_unit_request(slot: Slot):
	assert(self.slot.slot_data)
	if slot != self.slot:
		return
	
	self.build_panels()	
	self.show()
	
func clean_up():
	self.remove_child_panels()
	self.hide()
	
func build_panels():
	assert(self.slot.slot_data)
	self.remove_child_panels()
	#Build panels 
	for skill_tree_item_data in self.slot.slot_data.unit_data.skill_tree.skill_tree_level_1:
		var panel = panel_scene.instantiate()
		panel_container.add_child(panel)
		panel.set_data(skill_tree_item_data)
		panel.init_from_data()
		panel.level_clicked.connect(self.on_level_clicked)

func on_level_clicked(skill_tree_item_data: SkillTreeItemData):
	# Update Attribute
	slot.slot_data.unit_data.stat_data.updateAttribute(skill_tree_item_data.attribute_link, slot.slot_data.unit_data.stat_data.getAttribute(skill_tree_item_data.attribute_link).value + 1)
	EncounterBus.slot_data_changed.emit()
	
	EncounterBus.level_up_finished.emit()
	self.clean_up()
	await self.slot.unit_ui.action_displayer.display_custom("+" + \
	 GameData.getStringEnumByIndex( "UNIT_DATA_ATTRIBUTES", skill_tree_item_data.attribute_link) )
	
#func on_slot_data_changed():
#	assert(self.slot_data)
#	self.build_panels()
