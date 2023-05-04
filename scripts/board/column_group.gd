extends Control
class_name UnitColGroup

const SiegeColumnScene = preload("res://scenes/board/columns/siege_column.tscn")
const InfantryColumnScene = preload("res://scenes/board/columns/ranged_column.tscn")
const RangedColumnScene = preload("res://scenes/board/columns/infantry_column.tscn")



var column_dict : Dictionary
var isEnemy: bool
var loading: bool = true

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
	for slot_data in data.slot_datas:
		print("slot_data.column_name:  %s"  % slot_data.column_name)
		print(GameData[GameData.COLUMN_STRING.keys()[slot_data.column_name]])
		column_dict[GameData[GameData.COLUMN_STRING.keys()[slot_data.column_name]]].add_slot(slot_data)

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
	#
	#unit_data
	#for unit in units:
	#
	# target = get_attack_target(unit)
	#
	# unit.attack(target)
	# //show animation, sound, update in data
	#
	# is target dead?
	# is unit dead?
	# //show animation, sound, update in data

 
	EncounterBus.fight_action_stopped.emit()
	


func on_encounter_state_changed(state_name : String) -> void:
	print("Signaled to on_encounter_state_changed %s" % state_name)
	
	
#func get_attack_order() -> Array[SlotData]:
##	for column in column_dict:
##		column_dict[column].column_data.slot_datas
#	pass
	
