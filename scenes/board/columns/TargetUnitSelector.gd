extends Control

var column_group : UnitColGroup
var active : bool = false
var active_action: GameData.UNIT_ACTIONS
var potential_targets : Array[SlotData] = []

@onready var texture_rect = $TextureRect
@onready var collision_shape_2d = $Area2D/CollisionShape2D

# This Node recieves a signal when it should look for Slot selection to fill a unit's action targets
# and emits a signal when action is set 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	EncounterBus.request_user_target_unit.connect(self.on_request_user_target_unit)
	EncounterBus.target_hovered.connect(self.on_target_hovered)
	EncounterBus.target_hover_exited.connect(self.on_target_hover_exited)
	EncounterBus.target_selected.connect(self.on_target_selected)
	EncounterBus.end_request_user_target_unit.connect(self.quit_targeting)
	await get_parent().ready
	assert(column_group)
	
	
	
func _process(delta):
	if active:
		# Make the 
		# Create a path from slot_data unit to mouse/target
		texture_rect.global_position = get_global_mouse_position() - Vector2(texture_rect.get_size().x/2, texture_rect.get_size().y/2)
		
	else:
		
		if self.is_visible_in_tree():
			self.hide()

func quit_targeting():
	self.hide()
	self.active = false
	self.active_action = 0
	self.potential_targets = []

func on_request_user_target_unit( action: GameData.UNIT_ACTIONS, potential_targets: Array[SlotData]):
	assert(GameData.ui_active_slot_data)
	assert(GameData.UNIT_ACTIONS.find_key(action))
		
	# Show the texture
	self.show()
	self.active = true
	self.active_action = action
	self.potential_targets = potential_targets


func _on_gui_input(event):
	# Right click:
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed() and active == true:
			# cancel
			EncounterBus.end_request_user_target_unit.emit()
	

func on_target_hovered(slot_data: SlotData):
	if slot_data in potential_targets:
		self.hide()
	
func on_target_hover_exited(slot_data: SlotData):
	if active:
		self.show()
	
func on_target_selected(slot_data: SlotData, button: int):
	print("selected from target")
	if active and GameData.ui_active_slot_data and slot_data in potential_targets:
		var adj_action_targets : Array[SlotData] = GameData.ui_active_slot_data.action_targets
		# If Selecting
		if slot_data not in GameData.ui_active_slot_data.action_targets:
			if len(adj_action_targets) >= GameData.ui_active_slot_data.unit_data.number_of_targets(active_action) :
				adj_action_targets.pop_back()
				adj_action_targets.append(slot_data)
			else:
				adj_action_targets.append(slot_data)
		else:
			# DE-selecting
			var test = adj_action_targets.find(slot_data)
			adj_action_targets.remove_at(test)
			
		GameData.ui_active_slot_data.action_targets = adj_action_targets
		EncounterBus.slot_data_changed.emit()
