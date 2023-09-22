extends Control
class_name OrderUi
@onready var v_box_container = $PanelContainer/VBoxContainer


var saved_data : SlotDataGroup
var order_ui_panel = preload("res://scenes/encounter/order_ui_panel.tscn")
var allow_movement : bool = false

@export var allowed_states : Array[String] = [GameData.ORDER]
# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to Encounter State Machine signals
	self.hide()
	
	UiManager.register_ui_module(self as OrderUi)
	
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_from_slot_data_group(data: SlotDataGroup):
	
	saved_data = data
	# TODO: Dont reinstance every time
	for child in v_box_container.get_children():
		child.queue_free()
		
	var reordered_slot_datas = GameData.full_slot_array.filter(func(slot_data): return slot_data.isEnemyUnit != true)

	
	for slot_data in reordered_slot_datas:
		# Create new panel for each
		var panel = order_ui_panel.instantiate()
		panel.order_ui = self
		panel.slot_data = slot_data
		panel.get_node("%UnitImage").texture = slot_data.unit_data.texture
		panel.get_node("%NameLabel").text = str(slot_data.unit_data.name)
		panel.get_node("%OrderLabel").text = str(slot_data.action_order)
		panel.get_node("%HealthBar").update(slot_data.unit_data)
		
		v_box_container.add_child(panel)
		panel.update_ui()
		
		

func on_encounter_state_changed(state: String):
	match state:
		"Order":
			self.allow_movement = true
		_:
			self.allow_movement = false

func move_panel_up_or_down(panel: Panel, up_or_down: String, slot_data: SlotData):
	if allow_movement != true:
		return
	
	var panel_to_switch
	match up_or_down:
		"up":
			panel_to_switch = v_box_container.get_child(panel.get_index()-1)
		"down":
			panel_to_switch = v_box_container.get_child(panel.get_index()+1)
	
	if panel_to_switch:
		var tmp = slot_data.action_order
		slot_data.action_order = panel_to_switch.slot_data.action_order
		panel_to_switch.slot_data.action_order = tmp
		#Tell everything that relys on slot_data to refresh
		EncounterBus.slot_data_changed.emit()
	
func on_slot_data_changed():
	# Current way to update ui
	load_from_slot_data_group(saved_data)
