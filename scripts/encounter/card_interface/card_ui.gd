extends Control
class_name  CardUi

@onready var debug_mode : bool = true

var unit_data : UnitDataTest
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_unit_data(data: UnitDataTest)-> void:
	self.unit_data = data

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
