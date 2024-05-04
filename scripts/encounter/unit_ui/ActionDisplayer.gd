extends Control
class_name ActionDisplayer

@onready var action_label: Label = %ActionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var action_label_container = $ActionLabelContainer
var slot_data : SlotData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#action_label.hide()
	action_label.set_self_modulate(Color(0,0,0,0)) 
	self.hide()
	

func initialize(slot_data):
	assert(slot_data)
	self.slot_data = slot_data


func display_action( action_data : ActionData) :
	
	action_label.text = action_data.name
	self.show()
	animation_player.play("fade_in_out")
	await animation_player.animation_finished
	action_label.set_self_modulate(Color(0,0,0,0)) 
	self.hide()
	return

func display_custom( custom_message: String):
		
	action_label.text = custom_message
	self.show()
	animation_player.play("fade_in_out")
	await animation_player.animation_finished
	action_label.set_self_modulate(Color(0,0,0,0)) 
	self.hide()
	return
