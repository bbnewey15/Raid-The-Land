extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _unhandled_key_input(event) -> void:
	print(event)
	if event.is_action_pressed("exit_game"):
		print("quitting")
		get_tree().quit()
		


