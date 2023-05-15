class_name CardHandInterface
extends Control


const CardSlot = preload("res://scenes/encounter/card_interface/card_slot.tscn")

@onready var unit_grid = $PanelContainer/MarginContainer/%CardGrid
var card_hand_data: CardHandData
var active_slot : CardSlotData
var encounter_manager: EncounterManager
	
	
func _ready():
	pass

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
		
		EncounterBus.card_slot_clicked.connect(Callable(self, "on_card_slot_clicked"))
		
		var parent  = get_parent_control()
		
		slot.set_slot_data(slot_data)
			
	# set pivot point for proper rotation
	self.set_pivot_offset(size/2)
	# set size to all column
	self.set_size(GameData.COLUMN_SIZE)
	

func on_card_slot_clicked(slot: CardSlot, index: int, button: int):
	print("Card selected %s \n index: %s\n button: %s" % [slot, index, button])
	active_slot = null
	match [active_slot, button]:
		[null, MOUSE_BUTTON_LEFT]:
			if active_slot:
				active_slot.setHighlight(false)
				
			active_slot = slot.slot_data
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			pass
		"Place":
			update_hand_ui()
		_:
			print("default")
			

func update_hand_ui() -> void:
	print("HAND UI")
	if active_slot:
		# Highlight Card
		active_slot.setHighlight(true)
