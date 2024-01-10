extends Node
class_name Action

signal action_selected(action_data: ActionData)

var action_data : ActionData 
@onready var color_rect = $ColorRect
@onready var attack_label = $AttackLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_action_data(data: ActionData) -> void:
	
	self.action_data = data
	attack_label.text = data.name
	


func _on_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			action_selected.emit(self.action_data as ActionData)
