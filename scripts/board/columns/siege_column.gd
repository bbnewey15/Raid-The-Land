class_name SiegeColumn
extends "res://scripts/board/unit_column.gd"
# SIEGE

# Called when the node enters the scene tree for the first time.
func _ready():
	super() # runs the parent lifecycle function
	# set position
	if isEnemy:
		self.set_position(GameData.siegeEnemyColumnLocation)
		self.set_rotation(deg_to_rad(GameData.siegeEnemyColumnRotation))
	else:
		self.set_position(GameData.siegeColumnLocation)
		self.set_rotation(deg_to_rad(GameData.siegeColumnRotation))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta) # runs the parent lifecycle function
	pass

#func set_is_enemy(value: bool) -> void:
#	super(value)
#	print("Ran set as child")
