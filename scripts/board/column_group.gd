extends Control
class_name UnitColGroup

const UnitColumnScene = preload("res://scenes/board/columns/unit_column.tscn")

@onready var target_unit_selector = $TargetUnitSelector

var column_dict : Dictionary
var isEnemy: bool
var loading: bool = true
var playerSlotDatas : Array[SlotData]
var enemySlotDatas : Array[SlotData]

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
	EncounterBus.fight_state_started.connect(self.on_fight_state_started)
	
	EncounterBus.action_activated.connect(self.on_action_activated)
	
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
		
		var sorted_array = GameData.sort_full_slot_datas(tmp_slot_array)
		
		# Set the action order
#		var action_order = 1;
#		for slot_data in sorted_array:
#			slot_data.action_order = action_order
#			action_order = action_order + 1
		
		GameData.full_slot_array = sorted_array
		# weird way to run UI updates and avoid an endless loop
		EncounterBus.slot_data_changed.emit(false)
	
	var encounter_manager = get_node("../")
	
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			pass

# func for handling order 
# TODO move to a node
func remove_and_append(start_idx : int , new_idx : int):
	# Use start_idx or start of array
	var saved_slot = GameData.full_slot_array.pop_at(start_idx if start_idx != null else 0)
	# Use new_dx unless null then use end of array
	GameData.full_slot_array.insert(new_idx if new_idx != null else len(GameData.full_slot_array)-1 , saved_slot)
	EncounterBus.slot_data_changed.emit()
	
func on_fight_state_started() -> void:
	self.fight()
	
	
# Probably make a node for AllActionManager that can manage multiple actions at once
func on_action_activated(slot_data  : SlotData):
	assert(slot_data)
	assert(slot_data.action_set)
	assert(slot_data.action_data)
	
	if slot_data.action_data.requires_target:
		var target_array = slot_data.action_targets
		for target in target_array:
			await slot_data.current_slot.unit_action(slot_data.action_data, target)
			var action_data = slot_data.action_data
			print("%s used [ %s] action %s " % [slot_data.unit_data.description, slot_data.action_data.name, target.unit_data.description])
			#await EncounterBus.unit_attack_finished
	else:
		await slot_data.current_slot.unit_action(slot_data.action_data, null)
		
	if slot_data.unit_data.action_points >= 0 or slot_data.action_data.will_end_turn:
		# end units turn
		slot_data.turn_over = true
		EncounterBus.slot_data_changed.emit()
	
	pass

func fight() -> void:
	#UnitColumnGroup on state: "fight"
	assert(GameData.full_slot_array)
	
	var run : bool = true
	# Find the first slot that needs an action
	while run:
		var result = await self.check_and_request_unit_action()
		# Check up on win condition
		var all_enemies_dead = false
		var test = GameData.full_slot_array.filter(func(x): return x.isEnemyUnit)
		var lam = func(y):  
			print( "Status %s" % y.unit_data.status)
			print( "UNIT data for alive: %s" % GameData.UNIT_STATUS.ALIVE )
			return y.unit_data.status == GameData.UNIT_STATUS.ALIVE 
		var test2 = test.any(lam)
		if test2 == false:
			run = false;
			continue
			
		# reset slot_data.turn_over if result is false
		if result == false:
			print("EVERYONE HAS ATTACKED RESETTING")
			for slot_data in GameData.full_slot_array:
				slot_data.turn_over = false;
			EncounterBus.slot_data_changed.emit()
			
	EncounterBus.fight_state_stopped.emit()
	
	
	
func check_and_request_unit_action():
	assert(GameData.full_slot_array)
	var found_slot : bool = false
	# Get First in attack order
	for slot_data in GameData.full_slot_array:
		if slot_data.isEnemyUnit == true:
			if !GameData.debug_mode:
				continue
		if slot_data.turn_over == true:
			continue
			
		var slot = slot_data.current_slot
		EncounterBus.action_request_ui.emit(slot)
		found_slot = true
		
		await EncounterBus.unit_turn_ended
		return true
		#Stop looping now that we found one
		#break
	
	
	if found_slot == false:
		# If it gets here, then no unit is available and we need to reset 
		return false

func get_potential_action_targets(slot_data: SlotData, action_data: ActionData) -> Array[SlotData]:
	var slot_actioning = slot_data.current_slot
	assert(slot_actioning, "No slot found for slot_data")
	
	var should_select_friendly : bool =  \
		true if action_data.target_type == GameData.ACTION_TARGET_TYPE.TARGET_ALLY else false
			
	var isEnemy = slot_data.isEnemyUnit
	
	var actioning_column : UnitColumn = slot_actioning.get_node("../../../")
	
	var targeted_columns : Array[UnitColumn] = []
	var range: Array = action_data.action_range
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
		if atk_col_index + distance <= len(GameData.COLUMN_STRING.keys())-1:
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

