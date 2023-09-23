extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update(unit_data: UnitDataTest):
	var health_label = self.get_node("HealthLabel")
	var health_bar_texture = self.get_node("HealthBarTexture")
	
	var new_health = clamp(unit_data.health, 0.0, unit_data.max_health)
	
	if health_bar_texture:
		health_bar_texture.value= ( float(new_health) / unit_data.max_health ) * 100
	var a = self.get_node("../")
	if health_label:
		health_label.text = str(new_health)
