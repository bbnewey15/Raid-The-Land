extends Control
class_name  UnitUi

@onready var debug_mode : bool = true
@onready var health_bar_texture = $HealthBar/HealthBarTexture
@onready var health_label = $HealthBar/HealthLabel

var unit_data : UnitDataTest
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_unit_data(data: UnitDataTest)-> void:
	self.unit_data = data
	var new_health = clamp(data.health, 0.0, unit_data.max_health)
	health_bar_texture.value = new_health
	health_label.text = str(new_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
