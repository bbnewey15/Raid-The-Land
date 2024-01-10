extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func run_tween(node_to_tween):
	# Attacked animation
	var tween: Tween = create_tween()
	#tween.tween_property(unit_node, "modulate:v", 1, 0.25).from(15)
	
	
	tween.set_ease(Tween.EASE_OUT)
	#tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(   # rotateTween is the name of the Tween node. This is telling Godot to create a new animation using this Tween node object.
		node_to_tween,                    # hexagonTile is the 3D tile we want to animate.
		"scale",              # When the Tween runs its animation, it will start at the tile's current rotation.
		Vector2(0,0),        # When the Tween runs its animation, it will end at 60 degrees clockwise from the tile's last rotation.
		.3,                           # This is the amount of time in seconds you want the Tween to run the animation for. This means that on the first run, 
									# the Tween's animation will rotate the tile from 0 degrees to 60 degrees in 1/4 of a second.
	).from_current()
	
	
	await tween.finished
