extends Control

@onready var panel_container = %PanelContainer
const panel_scene = preload("res://scenes/encounter/unit_ui/level_up_panel.tscn")
var slot_data : SlotData

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	for child in panel_container.get_children():
		child.queue_free()
		
	#connect to on_level_up_unit_request signal
	
	# Hacky
	var test = get_parent().get_parent().get_parent()
	
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)

func initialize():
	assert(slot_data)
	self.build_panels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_level_up_unit_request(unit_data: UnitDataTest):
	self.show()
	
func build_panels():
	#Build panels 
	for skill_tree_item_data in self.slot_data.unit_data.skill_tree.skill_tree_level_1:
		var panel = panel_scene.instantiate()
		panel_container.add_child(panel)
		panel.set_data(skill_tree_item_data)
		panel.init_from_data()

func on_slot_data_changed():
	assert(self.slot_data)
	self.build_panels()
