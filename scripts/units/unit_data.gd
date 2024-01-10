class_name UnitDataTest extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var unit_node_path: String
@export var column_type: GameData.COLUMN_TYPE
@export var max_health: int = 100
@export var max_ap : int = 5
@export var damage: int = 35
@export var support_amount : int = 15
@export var defend_ratio: float = .60
@export var status: GameData.UNIT_STATUS =  GameData.UNIT_STATUS.ALIVE
@export var eagerness = 10
@export var health = max_health
@export var action_points : int = max_ap
@export var conditions : Array[ConditionData] = []
@export var action_manager : ActionManager 


signal unit_moved(id: int, direction: GameData.MOVE_DIRECTION)

# Put all methods for actions here?

func move_unit(direction: GameData.MOVE_DIRECTION ):
	unit_moved.emit(self.get_instance_id(), direction)
	
func update_health(new_health: int):
	health = new_health


func add_condition(condition_data: ConditionData):
	var same_condition : Array[ConditionData] = self.conditions.filter(func(x): return x.condition == condition_data.condition)
	if len(same_condition)==0:
		self.conditions.append(condition_data)
	else:
		var handled = false
		for condition in same_condition: 
			if condition.ratio == condition_data.ratio:
				# Add stacks to existing
				var idx = self.conditions.find(condition)
				self.conditions[idx].stacks += condition_data.stacks
				handled = true
		if !handled:
			self.conditions.append(condition_data)
		
	print(conditions)
	
