extends Control
class_name UnitColGroup

const UnitColumnScene = preload("res://scenes/board/columns/unit_column.tscn")

@onready var target_unit_selector = $TargetUnitSelector

var column_dict : Dictionary
var isEnemy: bool
var loading: bool = true
var playerSlotDatas : Array[SlotData]
var enemySlotDatas : Array[SlotData]
var active_slot_data : SlotData


# Called when the node enters the scene tree for the first time.
func _ready():
	
	column_dict = {
		# We instantiate here and not place in scene so we can add params before placing
		# Init with params before adding child, ie before _ready() runs
		
		# Init all columns
		GameData.PLAYER_FRONT_COL : UnitColumnScene.instantiate().init(false, GameData.COLUMN_TYPE.FRONT, GameData.frontColumnLocation),
		GameData.PLAYER_BACK_COL : UnitColumnScene.instantiate().init(false, GameData.COLUMN_TYPE.BACK, GameData.backColumnLocation),
		GameData.ENEMY_FRONT_COL : UnitColumnScene.instantiate().init(true, GameData.COLUMN_TYPE.FRONT, GameData.frontEnemyColumnLocation),
		GameData.ENEMY_BACK_COL : UnitColumnScene.instantiate().init(true, GameData.COLUMN_TYPE.BACK, GameData.backEnemyColumnLocation)
	}
	
	# Pass data down to components
	target_unit_selector.column_group = self
	
	
	# Add signals
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	EncounterBus.player_turn_state_started.connect(self.on_player_turn_state_started)
	EncounterBus.enemy_turn_state_started.connect(self.on_enemy_turn_state_started)
	
#	# Connect to Encounter State Machine signals
#	encounterStateMachine.encounter_state_changed.connect(self.on_encounter_state_changed)
	
	loading = false
	
func load_from_resource(data: Resource) -> void:
	for column in column_dict:
		# Add to tree
		add_child(column_dict[column])
		column_dict[column].load_from_resource(data[column])
		# Connect to signals
		#column_dict[column].column_data.column_interact.connect(on_column_interact)
		
func load_from_slot_data_group(data: SlotDataGroup) -> void:
	# Save reference to Slot Data Arrays
	if data.isEnemy:
		enemySlotDatas = data.slot_datas
	else:
		playerSlotDatas = data.slot_datas
		
	for slot_data in data.slot_datas:
		print("slot_data.column_name:  %s"  % slot_data.column_name)
		print(GameData[GameData.COLUMN_STRING.keys()[slot_data.column_name]])
		column_dict[GameData.getColumnStringByIndex(slot_data.column_name)].add_slot(slot_data, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !loading:
		pass
		
func _physics_process(delta):
	pass


#func on_column_interact(unit_col_data: UnitColumnData, index: int, colIndex: int, button: int) -> void:
#	print("%s \n index: %s\n colIndex: %s\n %s" % [unit_col_data, index,colIndex, button])
#	active_slot_data = null
#	match [active_slot_data, button]:
#		[null, MOUSE_BUTTON_LEFT]:
#			active_slot_data = unit_col_data.grab_slot_data(index)	
#
#	update_actionUI()
	


func on_slot_data_changed(update_action_order: bool = true):
	if update_action_order == true || GameData.full_slot_array == null:
		# Current way to update ui
		var tmp_slot_array : Array[SlotData] 
		tmp_slot_array.append_array(playerSlotDatas)
		tmp_slot_array.append_array(enemySlotDatas)
		tmp_slot_array.sort_custom(GameData.eagernessOrderComparison)
		
		# Set the action order
		var action_order = 1;
		for slot_data in tmp_slot_array:
			slot_data.action_order = action_order
			action_order = action_order + 1
		
		GameData.full_slot_array = tmp_slot_array
		# weird way to run UI updates and avoid an endless loop
		EncounterBus.slot_data_changed.emit(false)
	
	var encounter_manager = get_node("../")
	
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"PlayerTurn":
			pass

	
func on_player_turn_state_started() -> void:
	self.fight()
	
func on_enemy_turn_state_started()->void:
	pass

func fight() -> void:
	#UnitColumnGroup on state: "fight"
	assert(GameData.full_slot_array)
	
	# Find the first slot that needs an action
	self.check_and_request_unit_action()
#
#	#unit_data
#	#for unit in units:
#	for slot_data in GameData.full_slot_array:
#		if slot_data.can_action() && slot_data.action_order:
#
#			if !slot_data.action_set:
#				continue
#			# Units act according to slot_data.action
#
#			if slot_data.unit_data.requires_target(slot_data.action):
#				var target_array = slot_data.action_targets
#				for target in target_array:
#					await slot_data.current_slot.unit_action(slot_data.action, target)
#					print("%s attacked %s " % [slot_data.unit_data.description, target.unit_data.description])
#					#await EncounterBus.unit_attack_finished
#			else:
#				await slot_data.current_slot.unit_action(slot_data.action, null)
#
#	EncounterBus.player_turn_state_stopped.emit()
	
	
	
func check_and_request_unit_action() -> void:
	assert(GameData.full_slot_array)
	# Get First in attack order
	for slot_data in GameData.full_slot_array:
		if slot_data.isEnemyUnit == true:
			if !GameData.debug_mode:
				continue
		if slot_data.action_set != false:
			continue
			
		var slot = slot_data.current_slot
		EncounterBus.action_request_ui.emit(slot)
		
		#Stop looping now that we found one
		break
	

func get_potential_action_targets(slot_data: SlotData, action: GameData.UNIT_ACTIONS) -> Array[SlotData]:
	var slot_actioning = slot_data.current_slot
	assert(slot_actioning, "No slot found for slot_data")
	
	var should_select_friendly : bool = false
	match action:
		GameData.UNIT_ACTIONS["ATTACK"]:
			pass
		GameData.UNIT_ACTIONS["DEFEND"]:
			pass
		GameData.UNIT_ACTIONS["SUPPORT"]:
			should_select_friendly = true
		_:
			push_warning("Default value used in unit_data's requires_target")
			
	var isEnemy = slot_data.isEnemyUnit
	
	var actioning_column : UnitColumn = slot_actioning.get_node("../../../")
	
	var targeted_columns : Array[UnitColumn] = []
	var range: Array = slot_data.unit_data.get_range_by_action(action)
	assert(range, "No Range set")
	
	var atk_col_index = actioning_column.column_data.colIndex
	
	for distance in range:
		# If enemy actioning at left end
		if atk_col_index - distance >= 0:
			var tmp_index =atk_col_index - distance
			
			var tmp = column_dict[GameData.getColumnStringByIndex(tmp_index)]
			if (isEnemy and !tmp.isEnemy) if !should_select_friendly else (isEnemy and tmp.isEnemy):
				targeted_columns.append(tmp)
			if (!isEnemy and tmp.isEnemy) if !should_select_friendly else (!isEnemy and !tmp.isEnemy):
				targeted_columns.append(tmp)
			
		# If player actioning at right end
		if atk_col_index + distance <= 5:
			var tmp_index =atk_col_index + distance
			
			var tmp = column_dict[GameData.getColumnStringByIndex(tmp_index)]
			if (isEnemy and !tmp.isEnemy) if !should_select_friendly else (isEnemy and tmp.isEnemy):
				targeted_columns.append(tmp)
			if (!isEnemy and tmp.isEnemy) if !should_select_friendly else (!isEnemy and !tmp.isEnemy):
				targeted_columns.append(tmp)
	
	var actionable_slots: Array[SlotData] = []
	for column in targeted_columns:
		for slot in column.unit_grid.get_children():
			actionable_slots.append(slot.slot_data)
	
	return actionable_slots
			

func on_encounter_state_changed(state_name : String) -> void:
	print("Signaled to on_encounter_state_changed %s" % state_name)
	

func find_available_columns_to_add_to(isEnemy: bool = false):
	var adj_is_enemy : bool = isEnemy or GameData.acting_as_enemy
	
	var columns_available = []
	for column in column_dict:
		if column_dict[column].isEnemy == adj_is_enemy:
			columns_available.append(column)
	return columns_available

