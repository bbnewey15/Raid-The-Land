extends Control
class_name  UnitUi

# Props from parent
var slot : Slot

@onready var debug_mode : bool = true
@onready var health_bar_texture = $HealthBar/HealthBarTexture
@onready var health_label = $HealthBar/HealthLabel
@onready var order_control = %OrderControl
@onready var order_control_label = %OrderControl/Label
@onready var action_control = %ActionControl
@onready var action_control_texture_rect = %ActionControl/TextureRect

var unit_data : UnitDataTest



# Called when the node enters the scene tree for the first time.
func _ready():
	order_control.hide()
	action_control.hide()
	action_control_texture_rect.set_texture(null)
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	
	await get_parent().ready
	assert(slot)

func set_unit_data(data: UnitDataTest)-> void:
	self.unit_data = data
	var new_health = clamp(data.health, 0.0, unit_data.max_health)
	
	health_bar_texture.value= ( float(new_health) / unit_data.max_health ) * 100
	health_label.text = str(new_health)
	
func set_slot_data(data: SlotData)->void:
	order_control_label.text = str(data.action_order)
	if data.action_set:
		action_control_texture_rect.set_texture(GameData.get_icon_by_action(data.action))
	else:
		action_control_texture_rect.set_texture(null)
	if data.isEnemyUnit:
		order_control_label.add_theme_color_override("font_color","#ff5555")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_encounter_state_changed(state: String)-> void:
	if state == "Order" or state == "Fight":
		order_control.show()
		action_control.show()


	
