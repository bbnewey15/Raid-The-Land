extends Control
class_name EnemyIntent

@onready var intent_label: Label = %IntentLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var intent_label_container = $IntentLabelContainer
var slot_data : SlotData
var shouldShow : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#intent_label.hide()
	intent_label.set_self_modulate(Color(0,0,0,0)) 
	self.hide()
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	EncounterBus.new_round_started.connect(self.on_new_round_started)
	EncounterBus.action_completed.connect(self.on_action_completed)
	

func initialize(slot_data):
	assert(slot_data)
	self.slot_data = slot_data

func on_slot_data_changed():
	if not self.slot_data:
		return
	assert(self.slot_data)
	if self.shouldShow and slot_data.isEnemyUnit and slot_data.action_set:
		self.update_intent_ui(slot_data.action_data)
		if(!self.is_visible()):
			self.display_intent()
		
		
func on_new_round_started(round: int):
	self.shouldShow = true
	
		
func on_action_completed(slot_data: SlotData):
	if self.slot_data == slot_data:
		await self.hide_intent_animation()
		if(self.is_visible()): 
			self.hide()
			self.shouldShow = false
		
		slot_data.intent_ready.emit()
		
func update_intent_ui( action_data: ActionData):
	if action_data.action_type == GameData.UNIT_ACTIONS.ATTACK:
		intent_label.text = str(self.slot_data.unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.DAMAGE).value)
	else:
		intent_label.text = str(self.slot_data.unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.DAMAGE).value)

func display_intent() :

	self.show()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	#intent_label.set_self_modulate(Color(0,0,0,0)) 
	
	
func hide_intent_animation():
	animation_player.play("fade_out")
	return animation_player.animation_finished
