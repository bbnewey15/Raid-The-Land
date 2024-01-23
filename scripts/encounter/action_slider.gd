extends Control
@onready var polygon_2d = %Polygon2D
@onready var animation_player = $AnimationPlayer
@onready var slider_bar = %SliderBar
var active: bool = false
var saved_position: Vector2 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	animation_player.play("RESET")
	
	EncounterBus.action_slider_requested.connect(self.on_action_slider_requested)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_action_slider_requested(action_data: ActionData, slot_data: SlotData, target_slot_data: SlotData):
	self.show()
	self.active = true
	var speed = self.get_speed_based_of_slider(action_data, slot_data, target_slot_data)
	animation_player.play("slide", -1,speed)
	

func get_speed_based_of_slider(action_data: ActionData, slot_data: SlotData, target_slot_data: SlotData) -> float:
	return 6


func _on_gui_input(event):
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT) \
		and event.is_pressed() and active == true:
			# stop animation and find position
			saved_position = slider_bar.get_global_position()
			var slider_result : GameData.ACTION_SLIDER_HIT
			var test_2_position = polygon_2d.get_global_position()

			animation_player.stop(true)
			await get_tree().create_timer(.6).timeout
			# size of polygon2 is 20
			if saved_position.x < test_2_position.x + 20 and saved_position.x >  test_2_position.x:
				slider_result = GameData.ACTION_SLIDER_HIT.HIT
				print("HIT")
			if saved_position.x < test_2_position.x + 100 and saved_position.x >  test_2_position.x - 80:
				slider_result = GameData.ACTION_SLIDER_HIT.SLIGHT
			
			if slider_result == null:
				print("MISS - slider_x: %s and test_2_x: %s" % [saved_position.x, test_2_position.x] )
				slider_result = GameData.ACTION_SLIDER_HIT.MISS
				
			EncounterBus.action_slider_completed.emit(slider_result)
			self.hide()
			self.active = false
