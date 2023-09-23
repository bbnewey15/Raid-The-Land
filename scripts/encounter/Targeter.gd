extends Control

var slot : Slot 
var highlighted : bool = false
var actioned : bool = false
@onready var color_rect: ColorRect = $ColorRect
var targeting_active : bool = false
var active_action : GameData.UNIT_ACTIONS
var potential_targets : Array[SlotData]

@export var HIGHLIGHT_COLOR: Color = Color(0.894, 0.765, 0.263, 0.39)
@export var ATTACKING_COLOR: Color = Color(0.749, 0.078, 0.149, 0.351)
@export var SUPPORTING_COLOR: Color = Color(0.114, 0.718, 0.494, 0.353)
@export var UNHIGHLIGHT_COLOR: Color = Color(1, 1, 1, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	EncounterBus.action_request_ui.connect(self.on_action_request_ui)
	EncounterBus.request_user_target_unit.connect(self.on_request_user_target_unit)
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	EncounterBus.end_request_user_target_unit.connect(self.on_end_request_user_target_unit)
	EncounterBus.ui_active_slot_data_changed.connect(self.on_ui_active_slot_data_changed)
	
	await get_parent().ready
	self.unhighlight_slot()
	assert(slot)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_slot_data_changed():
	self.check_action_highlights()
	
func on_ui_active_slot_data_changed():
	self.check_action_highlights()
	
	
func highlight_slot(color: Color):
	self.show()
	highlighted = true
	self.color_rect.set_color(color)
	self.color_rect.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	
func unhighlight_slot():
	highlighted = false
	actioned = false
	self.color_rect.set_color(UNHIGHLIGHT_COLOR)
	self.hide()
	self.color_rect.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	
	
func on_action_request_ui(slot: Slot):
	check_action_highlights()
#	if GameData.ui_active_slot_data and GameData.ui_active_slot_data == self.slot.slot_data:
#		self.highlight_slot()


func on_request_user_target_unit( action: GameData.UNIT_ACTIONS, potential_targets: Array[SlotData]):
	assert(GameData.ui_active_slot_data)
	assert(GameData.UNIT_ACTIONS.find_key(action))
	assert(potential_targets)
	
	# Set state
	if GameData.ui_active_slot_data.unit_data.requires_target(action):
		self.potential_targets = potential_targets
		# Indicate that this unit is targetable
		if self.slot.slot_data in self.potential_targets:
			# target:  SlotData
			self.highlight_slot(HIGHLIGHT_COLOR)
			self.targeting_active = true
			self.active_action = action
		
		
	# Update UI according to state
	self.check_action_highlights()
	

func on_end_request_user_target_unit():
	self.unhighlight_slot()
	self.potential_targets = []
	self.active_action = 0
	self.targeting_active = false
	

func check_action_highlights():
	# Update UI according to state
	
	
	if GameData.ui_active_slot_data == null:
		self.on_end_request_user_target_unit()
		return
	
	self.unhighlight_slot()
	
	var targets = GameData.ui_active_slot_data.action_targets
	if self.slot.slot_data in targets:
		
		var color
		match GameData.ui_active_slot_data.action:
			GameData.UNIT_ACTIONS["ATTACK"]:
				color = self.ATTACKING_COLOR
			GameData.UNIT_ACTIONS["SUPPORT"]:
				color = self.SUPPORTING_COLOR
			_:
				push_warning("Default value used in check_action_highlights")
		
		# Currently targeted
		self.highlight_slot(color)
		self.actioned = true
	else:
		# Not currently targeted
		if self.slot.slot_data in self.potential_targets:
			# potentially a target
			self.actioned = false
			self.highlight_slot(HIGHLIGHT_COLOR)
			
	
	


func _on_color_rect_mouse_entered():
	if targeting_active and active_action != null:
		EncounterBus.target_hovered.emit(self.slot.slot_data)
		match active_action:
			GameData.UNIT_ACTIONS["ATTACK"]:
				if actioned:
					self.highlight_slot(ATTACKING_COLOR.lightened(.3))
				else:
					self.highlight_slot(HIGHLIGHT_COLOR.lightened(.3))
			GameData.UNIT_ACTIONS["DEFEND"]:
				pass
			GameData.UNIT_ACTIONS["SUPPORT"]:
				pass


func _on_color_rect_mouse_exited():
	if targeting_active and active_action != null:
		EncounterBus.target_hover_exited.emit(self.slot.slot_data)
		match active_action:
			GameData.UNIT_ACTIONS["ATTACK"]:
				if actioned:
					self.highlight_slot(ATTACKING_COLOR)
				else:
					self.highlight_slot(HIGHLIGHT_COLOR)
			GameData.UNIT_ACTIONS["DEFEND"]:
				pass
			GameData.UNIT_ACTIONS["SUPPORT"]:
				pass



func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Target Clicked %s" % event )
			# Have to update position
			EncounterBus.target_selected.emit(self.slot.slot_data,event.button_index)
	pass # Replace with function body.
