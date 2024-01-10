extends Panel

var order_ui : OrderUi
var slot_data : SlotData
@onready var color_rect = %ColorRect
@onready var action_texture_rect = %ActionControl/MarginContainer/TextureRect
@onready var shrink_tween: Node2D = %ShrinkTween
@onready var unit_image: TextureRect = %UnitImage

const ACTIVE_COLOR : Color =  Color(0.373, 0.965, 0.855, 0.318)
const INACTIVE_COLOR : Color = Color(1,1,1,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	EncounterBus.ui_active_slot_data_changed.connect(self.on_ui_active_slot_data_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_ui_active_slot_data_changed():
	self.update_ui()
	
	
func set_slot_data(slot_data: SlotData):
	if !self.is_node_ready():
		await self.ready
	
	self.get_node("%UnitImage").texture = slot_data.unit_data.texture
	self.get_node("%NameLabel").text = str(slot_data.unit_data.name)
	#self.get_node("%OrderLabel").text = str(slot_data.action_order)
	self.get_node("%HealthBar").update(slot_data.unit_data)
	
	self.slot_data = slot_data
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
		action_texture_rect.set_texture(slot_data.action_data.icon_path)
	else:
		action_texture_rect.set_texture(null)
		
	# Set variation of theme depending on enemy
	if self.slot_data.isEnemyUnit:
		self.set_theme_type_variation("OrderUiPanelEnemy")
	else:
		self.set_theme_type_variation("OrderUiPanel")


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
			
func remove():
	#await shrink_tween.run_tween(self)
	self.queue_free()
