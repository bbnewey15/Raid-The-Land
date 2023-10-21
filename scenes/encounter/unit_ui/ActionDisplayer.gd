extends Control
class_name ActionDisplayer

@onready var action_label: Label = %ActionLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_label.hide()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display_action( action_data : ActionData, slot_data: SlotData) :
	set_fade_progress(0)
	action_label.show()
	action_label.text = action_data.name
	return await fade_in_label()

func set_fade_progress( progress: float):
	assert(progress >= 0 and progress <= 1)
	var shader_material : Material = action_label.get_material()
	shader_material.set_shader_parameter("fade_progress", progress)
	

func fade_in_label():
	var shader_material : Material = action_label.get_material()
	var fade_animation = create_tween()
	fade_animation.set_ease(Tween.EASE_IN_OUT)
	fade_animation.set_trans(Tween.TRANS_LINEAR)
	fade_animation.tween_property(shader_material, "shader_parameter/fade_progress", 1.0, 1.5).from(0)
	return await fade_animation.finished
	
