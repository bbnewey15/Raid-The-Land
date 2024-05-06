extends Resource
class_name ConditionData

@export var condition : GameData.CONDITIONS
@export var stacks : int
@export var ratio : float
@export var icon : Texture2D 

var saved_attribute_adjustment_value = null

func execute(unit_data: UnitDataTest):
	
	# HEAL, WEAKEN,STRENGTHEN , SHAKEN, INSPIRED, INFECT , CURE
	match condition:
		GameData.CONDITIONS.HEAL:
			var healing_done = unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.SUPPORT_AMOUNT).value * ratio
			print("self.slot_data.unit_data.health - healing_done %s" % str(unit_data.health - healing_done))
			var new_health = unit_data.health + healing_done
		
		
			if new_health > unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.MAX_HEALTH).value:
				new_health = unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.MAX_HEALTH).value
		
			# Update unit datas new health
			unit_data.update_health(new_health)
			
		GameData.CONDITIONS.WEAKEN:
			pass
		GameData.CONDITIONS.STRENGTHEN:
			pass
		GameData.CONDITIONS.SHAKEN:
			pass
		GameData.CONDITIONS.INSPIRED:
			pass
		GameData.CONDITIONS.INFECT:
			pass
		GameData.CONDITIONS.CURE:
			pass
		GameData.CONDITIONS.DEFEND:
			# This condition does not stack
			if saved_attribute_adjustment_value:
				unit_data.stat_data.updateAttribute(GameData.UNIT_DATA_ATTRIBUTES.DEFEND_RATIO, unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.DEFEND_RATIO).value - saved_attribute_adjustment_value)
				self.saved_attribute_adjustment_value = null
				
			var current_attr = unit_data.stat_data.getAttribute(GameData.UNIT_DATA_ATTRIBUTES.DEFEND_RATIO).value
			var new_attr = current_attr * ratio
			
			self.saved_attribute_adjustment_value = new_attr
			unit_data.stat_data.updateAttribute(GameData.UNIT_DATA_ATTRIBUTES.DEFEND_RATIO, new_attr)
			
		_:
			print("Condition not found in execute")
			assert(false)
			
	self.stacks -= 1
	EncounterBus.slot_data_changed.emit()

func remove_condition(condition_data: ConditionData):
	match condition:
		GameData.CONDITIONS.HEAL:
			pass
		GameData.CONDITIONS.WEAKEN:
			pass
		GameData.CONDITIONS.STRENGTHEN:
			pass
		GameData.CONDITIONS.SHAKEN:
			pass
		GameData.CONDITIONS.INSPIRED:
			pass
		GameData.CONDITIONS.INFECT:
			pass
		GameData.CONDITIONS.CURE:
			pass
		GameData.CONDITIONS.DEFEND:
			pass
		_:
			print("Condition not found in remove_condition")
			assert(false)
