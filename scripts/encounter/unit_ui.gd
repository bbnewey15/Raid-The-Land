extends Control
class_name  UnitUi

@onready var debug_mode : bool = true
@onready var health_bar_texture = $HealthBar/HealthBarTexture
@onready var health_label = $HealthBar/HealthLabel
@onready var order_control = %OrderControl
@onready var order_control_label = $OrderControl/Label

var unit_data : UnitDataTest
# Called when the node enters the scene tree for the first time.
func _ready():
	order_control.hide()
	EncounterBus.encounter_state_changed.connect(self.on_place_state_started)
	EncounterBus.place_state_ended.connect(self.on_place_state_ended)
	pass # Replace with function body.

func set_unit_data(data: UnitDataTest)-> void:
	self.unit_data = data
	var new_health = clamp(data.health, 0.0, unit_data.max_health)
	
	health_bar_texture.value= ( float(new_health) / unit_data.max_health ) * 100
	health_label.text = str(new_health)
	
func set_slot_data(data: SlotData)->void:
	order_control_label.text = str(data.action_order)
	if data.isEnemyUnit:
		order_control_label.add_theme_color_override("font_color","#ff5555")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_place_state_started(state: String)-> void:
	if state == "Order":
		order_control.show()

func on_place_state_ended()-> void:
	order_control.hide()
