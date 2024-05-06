extends HBoxContainer

const condition_scene = preload("res://scenes/encounter/unit_ui/condition.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_unit_data(unit_data: UnitDataTest):
	for child in self.get_children():
		child.queue_free()
	
	for condition_data in unit_data.conditions:
		var condition = condition_scene.instantiate()
		self.add_child(condition)
		condition.set_condition_data(condition_data)
	
