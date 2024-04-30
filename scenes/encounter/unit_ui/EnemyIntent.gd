extends Control
class_name EnemyIntent

@onready var intent_label: Label = %IntentLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var intent_label_container = $IntentLabelContainer
var slot_data : SlotData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#intent_label.hide()
	intent_label.set_self_modulate(Color(0,0,0,0)) 
	self.hide()
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)
	EncounterBus.action_completed.connect(self.on_action_completed)
	

func initialize(slot_data):
	assert(slot_data)
	self.slot_data = slot_data

func on_slot_data_changed():
	assert(self.slot_data)
	if slot_data.isEnemyUnit and slot_data.action_set:
		if(!self.is_visible()):
			self.display_intent()
		self.update_intent(slot_data.action_data)
		
func on_action_completed(slot_data: SlotData):
	if self.slot_data == slot_data:
		self.hide_intent()
		
func update_intent( action_data: ActionData):
	if action_data.action_type == GameData.UNIT_ACTIONS.ATTACK:
		intent_label.text = str(self.slot_data.unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.DAMAGE).value)
	else:
		intent_label.text = str(self.slot_data.unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.DAMAGE).value)

func display_intent() :

	self.show()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	#intent_label.set_self_modulate(Color(0,0,0,0)) 
	
func hide_intent():
	self.hide()
	animation_player.play("fade_in")
	await animation_player.animation_finished
