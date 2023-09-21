extends Panel

var order_ui : OrderUi
var slot_data : SlotData
@onready var color_rect = $ColorRect

const ACTIVE_COLOR : Color =  Color(0.373, 0.965, 0.855, 0.518)
const INACTIVE_COLOR : Color = Color(1,1,1,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	EncounterBus.ui_active_slot_data_changed.connect(self.on_ui_active_slot_data_changed)
	EncounterBus.slot_data_changed.connect(self.on_slot_data_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_ui_active_slot_data_changed():
	self.update_ui()
	
func on_slot_data_changed():
	self.update_ui()
	
func update_ui():
	if GameData.ui_active_slot_data and GameData.ui_active_slot_data == slot_data:
		self.setActive(true)
	else:
		self.setActive(false)

func _on_move_up_button_pressed():
	order_ui.move_panel_up_or_down(self, "up",slot_data)


func _on_move_down_button_pressed():
	order_ui.move_panel_up_or_down(self, "down", slot_data)

func setActive(isActive : bool):
	if isActive:
		color_rect.set_color(ACTIVE_COLOR)
	else:
		color_rect.set_color(INACTIVE_COLOR)
