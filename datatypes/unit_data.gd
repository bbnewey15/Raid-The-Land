class_name UnitDataTest extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture
@export var unit_node_path: String
@export var column_type: GameData.COLUMN_TYPE

# If you add an attribute, add to GameData.UNIT_DATA_ATTRIBUTES
@export var stat_data: UnitStatData


@export var action_points : int 
@export var health : int
@export var status: GameData.UNIT_STATUS =  GameData.UNIT_STATUS.ALIVE


@export var conditions : Array[ConditionData] = []
@export var action_manager : ActionManager 
@export var skill_tree : SkillTreeData
@export var perk_list : Array[PerkData] = []


func initialize():
	assert(stat_data)
	assert(skill_tree)
	assert(unit_node_path)
	self.stat_data = self.stat_data.duplicate(true)
	self.stat_data.initialize()
	self.skill_tree = self.skill_tree.duplicate(true)
	self.perk_list = self.perk_list.duplicate(true)
	
	self.health = stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.MAX_HEALTH).value
	self.set_action_points_to_max()
	
	EncounterBus.new_round_started.connect(self.on_new_round_started)

# Put all methods for actions here?
	
func update_health(new_health: int):
	self.health = new_health
	
func update_action_points(new_action_points: int):
	if new_action_points < 0:
		assert(false)
		
	self.action_points = new_action_points
	
func set_action_points_to_max():
	self.update_action_points(stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.MAX_AP).value)


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
	
func remove_condition(condition_data: ConditionData):
	var existing_cond : Array[ConditionData] = self.conditions.filter(func(x): return x.condition == condition_data.condition)
	assert(len(existing_cond) > 0 )
	
	
func on_new_round_started(round: int):
	self.set_action_points_to_max()
	
