extends Panel

var order_ui : OrderUi
var slot_data : SlotData
@onready var color_rect = $ColorRect
@onready var action_texture_rect = %ActionControl/MarginContainer/TextureRect

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
	if !slot_data:
		return
	
	if GameData.ui_active_slot_data and GameData.ui_active_slot_data == slot_data:
		self.setActive(true)
	else:
		self.setActive(false)
	
	# Update ActionControl
	if slot_data.action_set:
		action_texture_rect.set_texture(GameData.get_icon_by_action(slot_data.action))
	else:
		action_texture_rect.set_texture(null)

func _on_move_up_button_pressed():
	order_ui.move_panel_up_or_down(self, "up",slot_data)


func _on_move_down_button_pressed():
	order_ui.move_panel_up_or_down(self, "down", slot_data)
	
	

func setActive(isActive : bool):
	if isActive:
		color_rect.set_color(ACTIVE_COLOR)
	else:
		color_rect.set_color(INACTIVE_COLOR)
		

func _on_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed():
			print("Order UI Panel Clicked %s" % event )
			#GameData.set_ui_active_slot_data(slot_data)
			EncounterBus.unit_selected.emit(slot_data, event.button_index)
			
