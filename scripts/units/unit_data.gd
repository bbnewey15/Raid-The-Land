extends Resource
class_name UnitData

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var column_type: GameData.COLUMN_TYPE


signal unit_moved(id: int, direction: GameData.MOVE_DIRECTION)

# Put all methods for actions here?

func move_unit(direction: GameData.MOVE_DIRECTION ):
	unit_moved.emit(self.get_instance_id(), direction)
	
