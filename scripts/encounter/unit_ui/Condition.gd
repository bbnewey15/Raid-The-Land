extends Control
class_name Condition
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_condition_data(condition_data: ConditionData):
	assert(condition_data)
	
	texture_rect.texture = condition_data.icon
	label.text = str(condition_data.stacks)
