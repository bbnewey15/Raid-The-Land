extends Resource
class_name CardData


@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var action_data: ActionData
#@export var card_type: GameData.CARD_TYPE

#
#signal card_played(id: int, direction: GameData.MOVE_DIRECTION)

# Put all methods for actions here?
#
#func move_unit(direction: GameData.MOVE_DIRECTION ):
#	unit_moved.emit(self.get_instance_id(), direction)
	
