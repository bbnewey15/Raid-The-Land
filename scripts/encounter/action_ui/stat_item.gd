extends MarginContainer
class_name StatItem

var unit_stat_item_data : UnitStatItemData
@onready var texture_rect = %TextureRect
@onready var label = %Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(unit_stat_item_data: UnitStatItemData):
	self.unit_stat_item_data = unit_stat_item_data
	self.texture_rect.set_texture(unit_stat_item_data.icon)
	self.label.set_text( str(unit_stat_item_data.value) )
	self.set_tooltip_text(unit_stat_item_data.display_name)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
