extends Panel

var order_ui : OrderUi
var slot_data : SlotData
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_move_up_button_pressed():
	order_ui.move_panel_up_or_down(self, "up",slot_data)


func _on_move_down_button_pressed():
	order_ui.move_panel_up_or_down(self, "down", slot_data)
