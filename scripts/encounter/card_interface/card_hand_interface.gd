class_name CardHandInterface
extends Control


const CardSlot = preload("res://scenes/encounter/card_interface/card_slot.tscn")

@onready var unit_grid = $PanelContainer/MarginContainer/%CardGrid
var card_hand_data: CardHandData

	
	
	
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_is_enemy(value: bool) -> void:
	self.isEnemy = value
	

# self must be in tree to run load_from_resource
func load_from_resource(data: CardHandData) -> void:
	# i think we have to save it otherwise it gets removed? and the signal no longer works
	card_hand_data= data
	
	# Clear cards
	for child in unit_grid.get_children():
			child.queue_free()
			
	for slot_data in card_hand_data.slot_datas:
		
		var slot = CardSlot.instantiate()
		
		unit_grid.add_child(slot)
		
		# Rotate slot so it is on the right angle
		var slot_text_rect : TextureRect = slot.get_node("MarginContainer/Control/%TextureRect")
		slot_text_rect.set_pivot_offset(slot.size/2)
		slot_text_rect.set_rotation_degrees(-self.get_rotation_degrees())
		
		# Add slot clicked signal
		slot.slot_clicked.connect(card_hand_data.on_slot_clicked)
#		print("is valid %s" %  column_data.on_slot_clicked.is_valid())
#		print("is connected? %s" % slot.is_connected("slot_clicked", column_data.on_slot_clicked))
#		print("has signal %s" % slot.has_signal("slot_clicked"))
#		print(slot.slot_clicked.get_connections())
		
		var parent  = get_parent_control()
		
		#slot.slot_clicked.connect(parent.)
		
		if slot_data:
			slot.set_slot_data(slot_data)
			
	# set pivot point for proper rotation
	self.set_pivot_offset(size/2)
	# set size to all column
	self.set_size(GameData.COLUMN_SIZE)
	

	
