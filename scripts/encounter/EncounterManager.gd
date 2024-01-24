extends Node

class_name EncounterManager


const ActionUIScene = preload("res://scenes/encounter/action_ui.tscn")
const AiActionManagerScene = preload("res://scenes/encounter/ai_action_manager.tscn")
@export var columnGroupDataResourcePath: String
@export var playerSlotDatasResourcePath: String
@export var encounter_enemy_roster: EncEnemyRosterData
@export var round : int = 0
const FiniteStateMachine = preload("res://scenes/encounter/encounter_state_machine.tscn")
@onready var order_ui = $OrderUi
@onready var encounter_ui = $EncounterUi
const slot_data_group_script = preload("res://datatypes/slot_data_group.gd")

var actionUI: ActionUI
var aiActionManager : AiActionManager
var loading: bool = true
var encounterStateMachine : StateMachine
var columnGroup : UnitColGroup


var columnGroupData : Resource
var playerSlotDatas : Resource
var enemySlotDatas : Array[SlotData]
# Called when the node enters the scene tree for the first time.
func _ready():
			
	columnGroupData = ResourceManager.load_specific_resources(columnGroupDataResourcePath)
	playerSlotDatas = ResourceManager.load_specific_resources(playerSlotDatasResourcePath)
	
	
	
		
	# Encounter State Machine
	encounterStateMachine = FiniteStateMachine.instantiate()
	encounterStateMachine.state_start = GameData.STATE_NAMES.START
	encounterStateMachine.encounter_manager = self as EncounterManager
	add_child(encounterStateMachine)
	
	# Instantiate and load columns
	columnGroup = get_node("%PlayerColumnGroup")
	columnGroup.load_from_resource(columnGroupData)
	
	# Add slot/slot_datas to columns from resource files
	columnGroup.load_from_slot_data_group(playerSlotDatas)
		

	# Instanciate and hide action UI
	actionUI = ActionUIScene.instantiate()	
	actionUI.encounter_manager = self as EncounterManager
	add_child(actionUI)
	actionUI.hide()
	
	aiActionManager = AiActionManagerScene.instantiate()
	aiActionManager.encounter_manager = self as EncounterManager
	add_child(aiActionManager)
	
	order_ui.encounter_manager = self as EncounterManager
	
	encounter_ui.encounter_manager = self as EncounterManager
	
	# Connect to Encounter State Machine signals
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	EncounterBus.new_round_started.connect(self.on_new_round_started)
	
	# Singal to everyone that slot data should be updated
	EncounterBus.slot_data_changed.emit()
	
	loading = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !loading:
		pass
		
		
func _physics_process(delta):
	pass


func on_encounter_state_changed(state_name : String) -> void:
	# Update UI Items based on state
	match state_name:
		"Start":
			pass
		"Draft":
			pass
		"Fight":
			pass
		"PostFight":
			pass
		
	
	
func build_enemies_by_round(round: int) :
	
	
	# Build enemies by round
	var enemySlotDatasArray: Array[SlotData] = []
	assert(encounter_enemy_roster)
	for roster_round in encounter_enemy_roster.encounter_roster:
		for enemy_roster_unit in roster_round.encounter_roster:
			if enemy_roster_unit.entry_delay == round:
				enemySlotDatasArray.append(enemy_roster_unit.slot_data)
				
	self.enemySlotDatas.append_array(enemySlotDatasArray)
				
	# Add slot/slot_datas to enemy columns from enc_enemy_roster_data
	var enemy_slot_data_group = slot_data_group_script.new()
	enemy_slot_data_group.slot_datas.append_array(enemySlotDatasArray)
	enemy_slot_data_group.isEnemy = true
	
	columnGroup.load_from_slot_data_group(enemy_slot_data_group)
	
func on_new_round_started(round: int):
	self.build_enemies_by_round(round)
	EncounterBus.ai_intent_request.emit(round)
