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
@onready var enemy_intent = %EnemyIntent
@onready var targeter = %Targeter
@onready var level_up_manager = %LevelUpManager
@onready var ap_container = %ApContainer
@onready var ap_label = %ApLabel
@onready var left_arrow_container = %left_arrow_container
@onready var right_arrow_container = %right_arrow_container

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
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	
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
	enemy_intent.initialize(self.slot.slot_data)
	if data.isEnemyUnit:
		ap_label.hide()
	else:
		ap_label.set_text(str(self.slot.slot_data.unit_data.action_points))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_encounter_state_changed(state: String)-> void:
	if state == "Fight":
		#order_control.show()
		action_control.show()
		
func update_ui():
	self.unhighlight_slot()
	self.left_arrow_container.hide()
	self.right_arrow_container.hide()
	if GameData.ui_active_slot_data and self.slot.slot_data == GameData.ui_active_slot_data:
		self.highlight_slot()
		if !GameData.ui_active_slot_data.isEnemyUnit:
			if GameData.ui_active_slot_data.unit_data.action_points >= 1:
				if GameData.ui_active_slot_data.column_name == GameData.COLUMN_STRING.PLAYER_BACK_COL:
					right_arrow_container.show()
				else:
					left_arrow_container.show()

func on_ui_active_slot_data_changed():
	update_ui()
					

func on_slot_data_changed():
	update_ui()
		
		

func highlight_slot(color: Color = DEFAULT_SELECT_COLOR):
	self.active_highlighter.set_color(color)
	
func unhighlight_slot():
	self.active_highlighter.set_color(UNHIGHLIGHT_COLOR)


func _on_left_arrow_container_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Left arrow Clicked %s" % event )
			if GameData.ui_active_slot_data == self.slot.slot_data:
				EncounterBus.slot_move_columns.emit(self.slot, GameData.COLUMN_STRING.PLAYER_BACK_COL)


func _on_right_arrow_container_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Right arrow Clicked %s" % event )
			if GameData.ui_active_slot_data == self.slot.slot_data:
				EncounterBus.slot_move_columns.emit(self.slot, GameData.COLUMN_STRING.PLAYER_FRONT_COL)
