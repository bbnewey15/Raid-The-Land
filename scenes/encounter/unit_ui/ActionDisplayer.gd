extends Control
class_name ActionDisplayer

@onready var action_label: Label = %ActionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#action_label.hide()
	action_label.set_self_modulate(Color(0,0,0,0)) 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display_action( action_data : ActionData, slot_data: SlotData) :
	
	action_label.text = action_data.name
	animation_player.play("fade_in_out")
	await animation_player.animation_finished
	action_label.set_self_modulate(Color(0,0,0,0)) 
	return

func display_custom( custom_message: String, slot_data: SlotData):
	action_label.text = custom_message
	animation_player.play("fade_in_out")
	await animation_player.animation_finished
	action_label.set_self_modulate(Color(0,0,0,0)) 
	return
