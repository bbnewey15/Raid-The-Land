extends Node
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_animation_parameters():
	animation_tree["parameters/conditions/attacking"] = true
