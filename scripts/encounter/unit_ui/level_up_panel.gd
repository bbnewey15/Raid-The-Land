extends Panel

@onready var indicator = %indicator
@onready var indicator_2 = %indicator2
@onready var indicator_3 = %indicator3

@onready var indicator_container = %IndicatorContainer

@export var total_indicators: Array[Polygon2D]
@export var skill_tree_item_data : SkillTreeItemData

signal level_clicked(skill_tree_item_data: SkillTreeItemData)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in indicator_container.get_children():
		child.hide()
		
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)


func set_data(skill_tree_item_data: SkillTreeItemData):
	assert(skill_tree_item_data)
	self.skill_tree_item_data = skill_tree_item_data
	self.init_from_data()
	
func on_slot_data_changed():
	if !self.skill_tree_item_data:
		return
	self.init_from_data()
	
func init_from_data():
	assert(self.skill_tree_item_data)
	for child in indicator_container.get_children():
		child.hide()
	if self.skill_tree_item_data.current_level >= 1:
		indicator.show()
	if self.skill_tree_item_data.current_level >= 2:
		indicator_2.show()
	if self.skill_tree_item_data.current_level >= 3:
		indicator_3.show()
			
		

func _on_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			self.level_clicked.emit(self.skill_tree_item_data)


func _on_mouse_entered():
	pass # Replace with function body.


func _on_mouse_exited():
	pass # Replace with function body.
