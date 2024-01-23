
extends MarginContainer
class_name PerkItem

var perk_data : PerkData
@onready var texture_rect = %TextureRect
@onready var label = %Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(perk_data: PerkData):
	self.perk_data = perk_data
	self.texture_rect.set_texture(perk_data.icon)
	self.label.set_text( str(perk_data.name) )
	self.set_tooltip_text(perk_data.description)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
