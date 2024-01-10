extends Resource
class_name ConditionData

@export var condition : GameData.CONDITIONS
@export var stacks : int
@export var ratio : float
@export var icon : Texture2D 

func execute(unit_data: UnitDataTest):
	
	# HEAL, WEAKEN,STRENGTHEN , SHAKEN, INSPIRED, INFECT , CURE
	match condition:
		GameData.CONDITIONS.HEAL:
			var healing_done = unit_data.support_amount * ratio
			print("self.slot_data.unit_data.health - healing_done %s" % str(unit_data.health - healing_done))
			var new_health = unit_data.health + healing_done
		
		
			if new_health > unit_data.max_health:
				new_health = unit_data.max_health
		
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
		_:
			print("Condition not found in execute")
			assert(false)
			
	self.stacks -= 1
		
		
			
	EncounterBus.slot_data_changed.emit()
