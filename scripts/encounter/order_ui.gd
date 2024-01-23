extends Control
class_name OrderUi
@onready var v_box_container = $PanelContainer/HBoxContainer

var order_array : Array[SlotData] = []
var encounter_manager : EncounterManager

var order_ui_panel = preload("res://scenes/encounter/order_ui_panel.tscn")
var allow_movement : bool = false

@export var allowed_states : Array[String] = [GameData.FIGHT, GameData.DRAFT]
# Called when the node enters the scene tree for the first time.
func _ready():
	
	await self.get_parent().ready
	
	# Connect to Encounter State Machine signals
	self.hide()
	
	UiManager.register_ui_module(self as OrderUi, true)
	
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	EncounterBus.unit_turn_ended.connect(self.on_unit_turn_ended)
	EncounterBus.request_recalculate_unit_order.connect(self.on_request_recalculate_unit_order)
	EncounterBus.finished_recalculate_unit_order.connect(self.load_from_slot_data)
	
	# intialize the order
	self.on_request_recalculate_unit_order()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_request_recalculate_unit_order():
	# Current way to update ui
	var sorted_array = GameData.sort_full_slot_datas(GameData.full_slot_array)
	
	# Set the action order
#		var action_order = 1;
#		for slot_data in sorted_array:
#			slot_data.action_order = action_order
#			action_order = action_order + 1
	
	GameData.full_slot_array = sorted_array
	# weird way to run UI updates and avoid an endless loop
	
	EncounterBus.finished_recalculate_unit_order.emit()
	


func load_from_slot_data():
	for child in v_box_container.get_children():
		child.remove()
		#child.queue_free()
		
	# Full slot array is source of truth on order 
	var reordered_slot_datas = GameData.full_slot_array
	
	for slot_data in reordered_slot_datas:
		# Probably should move this to the reordered_slot_datas setter
		if slot_data.unit_data.status == GameData.UNIT_STATUS.DEAD:
			continue
		# Create new panel for each
		var panel = order_ui_panel.instantiate()
		panel.order_ui = self
		panel.set_slot_data(slot_data)
		
		v_box_container.add_child(panel)
		panel.update_ui()
		
func on_slot_data_changed():
	# Current way to update ui
	self.update_from_slot_data()
		
func update_from_slot_data():
	# Full slot array is source of truth on order 
	var reordered_slot_datas = GameData.full_slot_array
	
	for panel in v_box_container.get_children():
		for slot_data in reordered_slot_datas:
			if panel.slot_data == slot_data:
				panel.set_slot_data(slot_data)
		#panel.update_ui()
		
func on_unit_turn_ended(slot_data: SlotData):
	# Find slot data in panels
	for child in v_box_container.get_children():
		if child.slot_data == slot_data:
#			await child.shrink_tween.run_tween(child)
			pass
	

func on_encounter_state_changed(state: String):
	match state:
		"PlayerFight":
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
		# Update GameData.full_slot_array instead 
#		var tmp = slot_data.action_order
#		slot_data.action_order = panel_to_switch.slot_data.action_order
#		panel_to_switch.slot_data.action_order = tmp
#		#Tell everything that relys on slot_data to refresh
#		EncounterBus.slot_data_changed.emit()
		pass


