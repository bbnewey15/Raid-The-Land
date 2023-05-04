extends Node2D

# This Node should switch out chilren based
#   on what section of the game is active

var encounter_bg = preload("res://scenes/encounter_background.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# add our ecounter background for now
	print("adding scene")
	#var new_scene = encounter_bg.instantiate()
	#call_deferred("add_to_root", new_scene)
	
	pass # Replace with function body.

func add_to_root(instance):
	pass#get_tree().change_scene_to_file("res://scenes/encounter_background.tscn") #get_root().add_child(instance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
