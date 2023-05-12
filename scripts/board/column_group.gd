extends Control
class_name UnitColGroup

const SiegeColumnScene = preload("res://scenes/board/columns/siege_column.tscn")
const InfantryColumnScene = preload("res://scenes/board/columns/ranged_column.tscn")
const RangedColumnScene = preload("res://scenes/board/columns/infantry_column.tscn")



var column_dict : Dictionary
var isEnemy: bool
var loading: bool = true
var playerSlotDatas : Array[SlotData]
var enemySlotDatas : Array[SlotData]

var active_slot_data : SlotData

# Called when the node enters the scene tree for the first time.
func _ready():
	#Clear scence just in case
	for child in get_children():
		child.queue_free()
			
	
	column_dict = {
		# We instantiate here and not place in scene so we can add params before placing
		# Init with params before adding child, ie before _ready() runs
		
		# Init all columns
		GameData.PLAYER_SIEGE_COL : SiegeColumnScene.instantiate().init(false, GameData.COLUMN_TYPE.SIEGE),
		GameData.PLAYER_RANGED_COL : RangedColumnScene.instantiate().init(false, GameData.COLUMN_TYPE.RANGED),
		GameData.PLAYER_INFANTRY_COL : InfantryColumnScene.instantiate().init(false, GameData.COLUMN_TYPE.INFANTRY),
		GameData.ENEMY_SIEGE_COL : SiegeColumnScene.instantiate().init(true, GameData.COLUMN_TYPE.SIEGE),
		GameData.ENEMY_RANGED_COL : RangedColumnScene.instantiate().init(true, GameData.COLUMN_TYPE.RANGED),
		GameData.ENEMY_INFANTRY_COL : InfantryColumnScene.instantiate().init(true, GameData.COLUMN_TYPE.INFANTRY)
	}
	
	# Add signals
	EncounterBus.fight_action_started.connect(self.on_fight_action_started)

	
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
		column_dict[GameData.getColumnStringByIndex(slot_data.column_name)].add_slot(slot_data)

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
	
	
	
func on_fight_action_started() -> void:
	self.fight()

func fight() -> void:
	#UnitColumnGroup on state: "fight"
	#
	#put units in order by attack order and turn priority
	var full_slot_array : Array[SlotData] 
	full_slot_array.append_array(playerSlotDatas)
	full_slot_array.append_array(enemySlotDatas)
	full_slot_array.sort_custom(Callable(self,"attackOrderComparison") )
	#
	#unit_data
	#for unit in units:
	for slot_data in full_slot_array:
		if slot_data.can_attack && slot_data.attack_order:
			# target = get_attack_target(unit)
			var target_array = get_attack_target(slot_data)
			for target in target_array:
				slot_data.current_slot.attack(target)
				print("Unit: %s attacked Column: %s" % [slot_data.unit_data.name, GameData.getColumnStringByIndex(target.column_data.colIndex)])
	# 		
 
	EncounterBus.fight_action_stopped.emit()
	
func attackOrderComparison(a : SlotData, b : SlotData):
	if !a.can_attack:
		return true
	if !b.can_attack:
		return false
		
	if typeof(a.attack_order) != typeof(b.attack_order):
		return typeof(a.attack_order) < typeof(b.attack_order)
	else:
		return a.attack_order < b.attack_order

func get_attack_target(slot_data: SlotData) -> Array[UnitColumn]:
	var slot = slot_data.current_slot
	assert(slot, "No slot found for slot_data")
	
	var isEnemy = slot_data.isEnemyUnit
	
	var attacking_column : UnitColumn = slot.get_node("../../../")
	
	var targeted_columns : Array[UnitColumn] = []
	var range: Array
	# What kind of unit is this ? 
	match slot_data.unit_data.column_type:
		GameData.COLUMN_TYPE.INFANTRY:
			# Targets Adjacent Columns
			range = [1]
		GameData.COLUMN_TYPE.RANGED:
			# Targets Range 2 from Column
			range = [2]
		GameData.COLUMN_TYPE.SIEGE:
			# Targets up to 2 range
			range = range(1,2)
	
	assert(range, "No Range set")
	
	var atk_col_index = attacking_column.column_data.colIndex
	
	for distance in range:
		# If enemy attacking at left end
		if isEnemy && atk_col_index - distance >= 0:
			var tmp_index =atk_col_index - distance
			
			var tmp = column_dict[GameData.getColumnStringByIndex(tmp_index)]
			if !tmp.isEnemy:
				targeted_columns.append(tmp)
			
		# If player attacking at right end
		if !isEnemy && atk_col_index + distance <= 5:
			var tmp_index =atk_col_index + distance
			
			var tmp = column_dict[GameData.getColumnStringByIndex(tmp_index)]
			if tmp.isEnemy:
				targeted_columns.append(tmp)
	
	
	return targeted_columns
			

func on_encounter_state_changed(state_name : String) -> void:
	print("Signaled to on_encounter_state_changed %s" % state_name)
	
	
#func get_attack_order() -> Array[SlotData]:
##	for column in column_dict:
##		column_dict[column].column_data.slot_datas
#	pass
	
