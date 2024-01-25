class_name CardHandInterface
extends Control


const CardSlotScene = preload("res://scenes/encounter/card_interface/card_slot.tscn")


@onready var card_grid = %CardGrid
var card_hand_data: CardHandData
var encounter_manager: EncounterManager

@export var allowed_states : Array[String] = [GameData.FIGHT]
@export var example_hand : CardHandData = preload("res://resources/card_hand_data_example.tres")

func _ready():
	self.hide()


	UiManager.register_ui_module(self as CardHandInterface)

	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	EncounterBus.card_slot_clicked.connect(self.on_card_slot_clicked)
	#EncounterBus.card_post_play.connect(self.on_card_post_play)
	#EncounterBus.column_clicked.connect(self.on_column_clicked)
	EncounterBus.action_request_ui.connect(self.on_action_request_ui)
	EncounterBus.action_completed.connect(self.on_action_completed)
	
	self.load_from_resource(example_hand)

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
	for child in card_grid.get_children():
			child.queue_free()

	for card_slot_data in card_hand_data.slot_datas:

		var card_slot = CardSlotScene.instantiate()

		card_grid.add_child(card_slot)

		card_slot.set_slot_data(card_slot_data)
#
#	# set pivot point for proper rotation
#	self.set_pivot_offset(size/2)
#	# set size to all column
#	self.set_size(GameData.COLUMN_SIZE)
	
func on_action_request_ui(slot: Slot):
	
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":
			self.show()
			self.update_hand_ui()
		"PostFight":
			pass
		_:
			print("default")
	


func on_card_slot_clicked(slot: CardSlot):
	print("Card selected %s" % [slot])
	var old_active_slot : CardSlot = null

	var test = is_instance_valid(slot)
	match encounter_manager.encounterStateMachine.get_state_name():
		"Start":
			pass
		"Fight":

			old_active_slot = GameData.ui_active_card_slot
			GameData.set_ui_active_card_slot(slot)

			# Slot could be recently freed, so we check
			# TODO: There might be a better way to handle this
			if is_instance_valid(old_active_slot):
				old_active_slot.setHighlight(false)

			if is_instance_valid( GameData.ui_active_card_slot ):
				# Highlight Card
				GameData.ui_active_card_slot.setHighlight(true)
		_:
			print("default")
			
func on_action_completed(slot_data: SlotData):
	# Enemy will not play have an active card
	if slot_data.isEnemyUnit:
		return
		
	assert(GameData.ui_active_card_slot)
	self.on_card_post_play(GameData.ui_active_card_slot)


func update_hand_ui() -> void:
	print("HAND UI")


func on_card_post_play(card_slot: CardSlot):
	assert(card_slot)
	
	#Remove card from hand and free resources
	card_grid.remove_child(card_slot)
	card_slot.queue_free()
	GameData.set_ui_active_card_slot( null )


func on_encounter_state_changed(state_name):
	pass
