extends "res://scripts/board/unit_column.gd"

#INFANTRY

# Called when the node enters the scene tree for the first time.
func _ready():
	super() # runs the parent lifecycle function
	print("Inf col type %s" % column_type)
	# set position
	if isEnemy:
		self.set_position(GameData.infantryEnemyColumnLocation)
		self.set_rotation(deg_to_rad(GameData.infantryEnemyColumnRotation))
	else:
		self.set_position(GameData.infantryColumnLocation)
		self.set_rotation(deg_to_rad(GameData.infantryColumnRotation))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta) # runs the parent lifecycle function
