extends Node

class_name EncounterManager


const ActionUIScene = preload("res://scenes/encounter/action_ui.tscn")
@export var columnGroupDataResourcePath: String
@export var playerSlotDatasResourcePath: String
@export var enemySlotDatasResourcePath: String
const FiniteStateMachine = preload("res://scenes/encounter/encounter_state_machine.tscn")
@onready var order_ui = $OrderUi
@onready var encounter_ui = $EncounterUi


var actionUI: ActionUI
var loading: bool = true
var encounterStateMachine : StateMachine
var columnGroup : UnitColGroup


var columnGroupData : Resource
var playerSlotDatas : Resource
var enemySlotDatas : Resource
# Called when the node enters the scene tree for the first time.
func _ready():
			
	columnGroupData = ResourceManager.load_specific_resources(columnGroupDataResourcePath)
	playerSlotDatas = ResourceManager.load_specific_resources(playerSlotDatasResourcePath)
	enemySlotDatas = ResourceManager.load_specific_resources(enemySlotDatasResourcePath)
		
	# Encounter State Machine
	encounterStateMachine = FiniteStateMachine.instantiate()
	encounterStateMachine.state_start = 0
	encounterStateMachine.encounter_manager = self as EncounterManager
	add_child(encounterStateMachine)
	
	# Instantiate and load columns
	columnGroup = get_node("%PlayerColumnGroup")
	columnGroup.load_from_resource(columnGroupData)
	
	# Add slot/slot_datas to columns from resource files
	columnGroup.load_from_slot_data_group(playerSlotDatas)
	columnGroup.load_from_slot_data_group(enemySlotDatas)

	# Instanciate and hide action UI
	actionUI = ActionUIScene.instantiate()	
	actionUI.encounter_manager = self as EncounterManager
	add_child(actionUI)
	actionUI.hide()
	
	
	order_ui.load_from_slot_data_group(playerSlotDatas)
	
	encounter_ui.encounter_manager = self as EncounterManager
	
	# Connect to Encounter State Machine signals
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	
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
		"PlayerTurn":
			pass
		"PostFight":
			pass
		
	
	
	
