extends Control
class_name EncounterUi

var encounter_manager: EncounterManager

@export var allowed_states : Array[String] = [GameData.FIGHT, GameData.POST_FIGHT]

@onready var place_button_container = %PlaceButtonContainer
@onready var end_turn_button = %EndTurnButton
@onready var end_post_fight_button = %EndPostFightButton

# Called when the node enters the scene tree for the first time.
func _ready():
	await self.get_parent().ready
	
	self.hide()
	end_turn_button.hide()
	end_post_fight_button.hide()
	
	UiManager.register_ui_module(self as EncounterUi, true)
	
	EncounterBus.encounter_state_changed.connect(self.on_encounter_state_changed)
	EncounterBus.unit_turn_started.connect(self.on_unit_turn_started)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_encounter_state_changed(state_name: String):
	match state_name:
		"Start":
			place_button_container.hide()
		"Fight":
			place_button_container.show()
			end_turn_button.show()
		"PostFight":
			place_button_container.show()
			end_post_fight_button.show()
			
func on_unit_turn_started(slot_data: SlotData):
	if slot_data.isEnemyUnit:
		place_button_container.hide()
		return
		
	place_button_container.show()
	end_turn_button.show()


func _on_end_post_fight_button_pressed():
	if encounter_manager.encounterStateMachine.get_state_name() == "PostFight":
		place_button_container.hide()
		end_post_fight_button.hide()
		EncounterBus.post_fight_state_ended.emit()


func _on_end_turn_button_pressed():
	if encounter_manager.encounterStateMachine.get_state_name() == "Fight":
		place_button_container.hide()
		end_turn_button.hide()
		GameData.ui_active_slot_data.turn_over = true
		EncounterBus.unit_turn_ended.emit(GameData.ui_active_slot_data)
