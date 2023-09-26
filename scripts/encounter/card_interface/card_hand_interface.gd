class_name CardHandInterface
extends Control


const CardSlot = preload("res://scenes/encounter/card_interface/card_slot.tscn")


@onready var unit_grid = $PanelContainer/MarginContainer/%CardGrid
var card_hand_data: CardHandData
var active_slot : CardSlot
var encounter_manager: EncounterManager
	
@export var allowed_states : Array[String] = [GameData.PLAYER_TURN, GameData.DRAFT]

func _ready():
	self.hide()
	
	
	UiManager.register_ui_module(self as CardHandInterface)
	
	EncounterBus.encounter_state_changed.connect(Callable(self,"on_encounter_state_changed"))
	EncounterBus.card_slot_clicked.connect(Callable(self, "on_card_slot_clicked"))
	EncounterBus.card_post_play.connect(Callable(self,"on_card_post_play"))
	EncounterBus.column_clicked.connect(Callable(self,"on_column_clicked"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_is_enemy(value: bool) -> void:
	self.isEnemy = value
	

# self must be in tree to run load_from_resource
func load_from_resource(data: CardHandData) -> void:
	# i think we have to save it otherwise it gets removed? and the signal no longer works
	card_hand_data= data
	
	# Clear cards
	for child in unit_grid.get_children():
			child.queue_free()
			
	for slot_data in card_hand_data.slot_datas:
		
		var slot = CardSlot.instantiate()
		
		unit_grid.add_child(slot)
		
		slot.set_slot_data(slot_data)
			
	# set pivot point for proper rotation
	self.set_pivot_offset(size/2)
	# set size to all column
	self.set_size(GameData.COLUMN_SIZE)
	

func on_card_slot_clicked(slot: CardSlot, column_type: GameData.COLUMN_TYPE, index: int, button: int):
	print("Card selected %s \n index: %s\n button: %s" % [slot, index, button])
	var old_active_slot : CardSlot = null
	
	var test = is_instance_valid(slot)
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"PlayerTurn":
			
			old_active_slot = active_slot
			active_slot = null
			match [active_slot, button]:
				[null, MOUSE_BUTTON_LEFT]:
					active_slot = slot
			
			# Slot could be recently freed, so we check
			# TODO: There might be a better way to handle this
			if is_instance_valid(old_active_slot):
				old_active_slot.setHighlight(false)
				
			if is_instance_valid(active_slot):
				# Highlight Card
				active_slot.setHighlight(true)
		_:
			print("default")
			


func update_hand_ui(old_active_slot: CardSlot) -> void:
	print("HAND UI")
	
func on_column_clicked(column: UnitColumn, index: int, button: int):
	if active_slot and active_slot.highlighted:
		# Play the card:
		EncounterBus.card_played.emit(active_slot, active_slot.slot_data.unit_data.column_type, index, button)

func on_card_post_play(card_slot: CardSlot, column_type: GameData.COLUMN_TYPE, index: int, button: int):
	#Remove card from hand and free resources
	unit_grid.remove_child(card_slot)
	card_slot.queue_free()
	active_slot = null
	

func on_encounter_state_changed(state_name):
	pass
	
