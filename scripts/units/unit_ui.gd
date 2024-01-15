extends Control
class_name  UnitUi

# Props from parent
var slot : Slot

@onready var debug_mode : bool = true
@onready var health_bar_texture = %HealthBar/HealthBarTexture
@onready var health_label = %HealthBar/HealthLabel
@onready var order_control = %OrderControl
@onready var order_control_label = %OrderControl/Label
@onready var action_control = %ActionControl
@onready var action_control_texture_rect = %ActionControl/TextureRect
@onready var active_highlighter = %ActiveHighlighter
@onready var conditions: HBoxContainer = %Conditions
@onready var action_displayer: Control = %ActionDisplayer
@onready var targeter = %Targeter
@onready var level_up_manager = %LevelUpManager

signal loaded 

var unit_data : UnitDataTest

@export var DEFAULT_SELECT_COLOR: Color = Color(.5,.75,.75,.33)
@export var UNHIGHLIGHT_COLOR: Color = Color(1, 1, 1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	order_control.hide()
	action_control.hide()
	action_control_texture_rect.set_texture(null)
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	EncounterBus.ui_active_slot_data_changed.connect(self.on_ui_active_slot_data_changed)
	
	await get_parent().ready
	assert(slot)
	targeter.slot = self.slot as Slot
	loaded.emit()

func set_unit_data(data: UnitDataTest)-> void:
	self.unit_data = data
	var new_health = clamp(data.health, 0.0, unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.MAX_HEALTH).value)
	health_bar_texture.value= ( float(new_health) / unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.MAX_HEALTH).value ) * 100
	health_label.set_text( str(new_health) )
	
	conditions.set_unit_data(data)
	
	
func set_slot_data(data: SlotData)->void:
#	order_control_label.text = str(data.action_order)
	if data.action_set:
		action_control_texture_rect.set_texture(data.action_data.icon_path)
	else:
		action_control_texture_rect.set_texture(null)
#	if data.isEnemyUnit:
#		order_control_label.add_theme_color_override("font_color","#ff5555")
	targeter.slot = self.slot as Slot
	level_up_manager.initialize(self.slot)
	action_displayer.initialize(self.slot.slot_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_encounter_state_changed(state: String)-> void:
	if state == "Fight":
		#order_control.show()
		action_control.show()

func on_ui_active_slot_data_changed():
	if GameData.ui_active_slot_data and self.slot.slot_data == GameData.ui_active_slot_data:
		self.highlight_slot()
	else:
		self.unhighlight_slot()

func highlight_slot(color: Color = DEFAULT_SELECT_COLOR):
	self.active_highlighter.set_color(color)
	
func unhighlight_slot():
	self.active_highlighter.set_color(UNHIGHLIGHT_COLOR)
