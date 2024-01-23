extends Control
class_name DraftUi

@export var allowed_states : Array[String] = [GameData.DRAFT]
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	EncounterBus.draft_state_started.connect(self.on_draft_state_started)
	
	UiManager.register_ui_module(self as DraftUi, true)


func on_draft_state_started():
	self.show()
	
	
	
	
