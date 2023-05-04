extends "res://scripts/board/unit_column.gd"

# RANGED

# Called when the node enters the scene tree for the first time.
func _ready():
	super() # runs the parent lifecycle function
	# set position
	print("Ranged col type %s" % column_type)
	if isEnemy:
		print("GameData.rangedEnemyColumnLocation %s" % GameData.rangedEnemyColumnLocation)
		self.set_position(GameData.rangedEnemyColumnLocation)
		self.set_rotation(deg_to_rad(GameData.rangedEnemyColumnRotation))
	else:
		print("GameData.rangedColumnLocation %s" % GameData.rangedColumnLocation)
		self.set_position(GameData.rangedColumnLocation)
		self.set_rotation(deg_to_rad(GameData.rangedColumnRotation))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta) # runs the parent lifecycle function
	pass
